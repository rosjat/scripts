using System;
using System.Management.Automation;
using System.Net.Http;
using System.IO;
using System.Text;
using System.Text.Json;


namespace RandomStuffModule.Cmdlet.HPiLo;

[Cmdlet(VerbsCommon.Get, "HPiLoSystem")]
[OutputType(typeof(HpIloEntry))]
public class GetHPiLoSystemCommand : PSCmdlet
{
    [Parameter(
        Mandatory = true,
        Position = 0,
        ValueFromPipeline = true,
        ValueFromPipelineByPropertyName = true)]
    public string ComputerName { get; set; }

    [Parameter(
    Mandatory = true,
    Position = 1,
    ValueFromPipeline = true,
    ValueFromPipelineByPropertyName = true)]
    public string Credentials { get; set; }

    private string _urlBase;
    private PSCredential _credentials;
    private string _passwd;
    protected override void BeginProcessing()
    {
        WriteVerbose("Begin!");
        _urlBase = $"https://{ComputerName}/redfish/v1/Systems/1/";
        _credentials = Host.UI.PromptForCredential("Powershell credential request", "Enter your credentials.", Credentials, ComputerName);
        _passwd = IloHelper.SecureStringToString(_credentials.Password);
    }
    protected override void ProcessRecord()
    {
        WriteDebug(_urlBase);
        WriteDebug(_credentials.UserName);
        WriteDebug(_passwd);
        var handler = new HttpClientHandler()
        {
            ServerCertificateCustomValidationCallback = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
        };
        HttpClient _client = new(handler);
        HttpRequestMessage webRequest = new(HttpMethod.Get, _urlBase);
        webRequest.Headers.Authorization = new("Basic", Convert.ToBase64String(ASCIIEncoding.ASCII.GetBytes($"{Credentials}:{_passwd}")));
        HttpResponseMessage response = _client.Send(webRequest);
        WriteDebug(response.StatusCode.ToString());
        WriteDebug(response.Content.ToString());
        using (var reader = new StreamReader(response.Content.ReadAsStream()))
        {
            string content = reader.ReadToEnd();
            var test = JsonSerializer.Deserialize(content, typeof(HpIloEntry), SourceGenerationContext.Default) as HpIloEntry;
            WriteObject(test);

        }
    }
}


