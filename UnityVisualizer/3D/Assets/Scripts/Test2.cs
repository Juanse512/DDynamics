using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using UnityEngine;

public class UDPFloatReceiver : MonoBehaviour
{
    public int listenPort = 12345;
    public Transform targetTransform;

    private Thread udpThread;
    private volatile bool isRunning = false;
    private float latestFloatX = 0f;
    private float latestFloatY = 0f;
    private float latestFloatZ = 0f;
    private readonly object lockObj = new object();

    void Start()
    {
        isRunning = true;
        udpThread = new Thread(UDPListen);
        udpThread.IsBackground = true;
        udpThread.Start();
    }

    void UDPListen()
    {
        UdpClient udpClient = new UdpClient(listenPort);
        IPEndPoint remoteEP = new IPEndPoint(IPAddress.Any, listenPort);

        try
        {
            while (isRunning)
            {
                byte[] data = udpClient.Receive(ref remoteEP);
                Debug.Log("Received data of length: " + data.Length);
                if (data.Length >= 3 * sizeof(float))
                {
                    float valueX = BitConverter.ToSingle(data, 0);
                    float valueY = BitConverter.ToSingle(data, 4);
                    float valueZ = BitConverter.ToSingle(data, 8);
                    lock (lockObj)
                    {
                        latestFloatX = valueX;
                        latestFloatY = valueZ;
                        latestFloatZ = valueY;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Debug.LogError("UDP Listen Exception: " + ex.Message);
        }
        finally
        {
            udpClient.Close();
        }
    }

    void FixedUpdate()
    {
        float valueCopyX, valueCopyY, valueCopyZ;
        lock (lockObj)
        {
            valueCopyX = latestFloatX;
            valueCopyY = latestFloatY;
            valueCopyZ = latestFloatZ;
            Debug.Log("Received floats: x=" + valueCopyX + " y=" + valueCopyY + " z=" + valueCopyZ);
        }
        targetTransform.position = new Vector3(valueCopyX, valueCopyY, valueCopyZ);
    }

    void OnApplicationQuit()
    {
        isRunning = false;
        if (udpThread != null && udpThread.IsAlive)
        {
            udpThread.Join(1000);
        }
    }

    void OnDestroy()
    {
        isRunning = false;
        if (udpThread != null && udpThread.IsAlive)
        {
            udpThread.Join(1000);
        }
    }
}