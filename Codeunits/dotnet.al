dotnet
{
    assembly("System.Private.Xml")
    {
        type("System.Xml.Xsl.XslCompiledTransform"; XslCompiledTransform) { }
        type("System.Xml.XmlReader"; DotNetXmlReader) { }
        type("System.Xml.XmlWriter"; DotNetXmlWriter) { }
        type("System.Xml.XmlReaderSettings"; DotNetXmlReaderSettings) { }
        type("System.Xml.XmlWriterSettings"; DotNetXmlWriterSettings) { }
        type("System.Xml.Xsl.XsltSettings"; DotNetXsltSettings) { }
    }

    assembly("System.Private.CoreLib")
    {
        type("System.IO.StringReader"; DotNetStringReader) { }
        type("System.IO.MemoryStream"; DotNetMemoryStream) { }
    }


    assembly("WinSCPnet")
    {
        Version = '1.6.5.9849';
        Culture = 'neutral';
        PublicKeyToken = '2271ec4a3c56d0bf';

        type("WinSCP.Session"; "Session")
        {
        }

        type("WinSCP.SessionOptions"; "SessionOptions")
        {
        }

        type("WinSCP.TransferOptions"; "TransferOptions")
        {
        }

        type("WinSCP.Protocol"; "Protocol")
        {
        }

        type("WinSCP.TransferResumeSupport"; "TransferResumeSupport")
        {
        }

        type("WinSCP.TransferResumeSupportState"; "TransferResumeSupportState")
        {
        }

        type("WinSCP.TransferOperationResult"; "TransferOperationResult")
        {
        }

        type("WinSCP.TransferEventArgs"; "TransferEventArgs")
        {
        }

        type("WinSCP.FailedEventArgs"; "FailedEventArgs")
        {
        }

        type("WinSCP.OutputDataReceivedEventArgs"; "OutputDataReceivedEventArgs")
        {
        }

        type("WinSCP.FileTransferProgressEventArgs"; "FileTransferProgressEventArgs")
        {
        }

        type("WinSCP.QueryReceivedEventArgs"; "QueryReceivedEventArgs")
        {
        }
    }

    assembly("System")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Net.HttpStatusCode"; "HttpStatusCode")
        {
        }

        type("System.Collections.Specialized.NameValueCollection"; "NameValueCollection")
        {
        }

        type("System.Diagnostics.Process"; "Process")
        {
        }

        type("System.Diagnostics.ProcessStartInfo"; "ProcessStartInfo")
        {
        }

        type("System.Net.Sockets.TcpClient"; "TcpClient")
        {
        }

    }

    assembly("mscorlib")
    {
        Version = '2.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.IO.StreamWriter"; "StreamWriter")
        {
        }

        type("System.Text.Encoding"; "Encoding")
        {
        }
    }

    assembly("System.Net.Http")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b03f5f7f11d50a3a';

        type("System.Net.Http.HttpClient"; "HttpClient")
        {
        }

        type("System.Net.Http.HttpContent"; "HttpContent")
        {
        }

        type("System.Net.Http.HttpResponseMessage"; "HttpResponseMessage")
        {
        }
    }

    assembly("")
    {
        type(""; "")
        {
        }
    }

    assembly("IDAutomation.NetAssembly")
    {
        Version = '2014.5.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'f77ee95231f619c9';

        type("IDAutomation.NetAssembly.UniversalFontEncoder"; "UniversalFontEncoder")
        {
        }
    }

}
