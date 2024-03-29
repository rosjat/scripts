using System.Management.Automation;


namespace RandomStuffModule.Cmdlet.TimeServer;

[Cmdlet(VerbsCommon.Get, "TimeServer")]
[OutputType(typeof(RegeditEntry))]
public class GetTimeServerCommand : PSCmdlet
{
    [Parameter(
        Position = 0,
        ValueFromPipeline = true,
        ValueFromPipelineByPropertyName = true)]
    public string ComputerName { get; set; }

    protected override void BeginProcessing()
    {
        WriteVerbose("Begin!");
    }
    protected override void ProcessRecord()
    {
        WriteVerbose("Process start ... ");
        try
        {
            if(string.IsNullOrEmpty(ComputerName))
                TimeServer.GetEntries().ForEach(e =>  WriteObject(e));
            else
                WriteObject(TimeServer.Get(ComputerName));             
        }
        catch (System.Exception ex)
        {
            WriteObject(new ErrorRecord(ex, "EytryNotFound", ErrorCategory.InvalidData, ComputerName));
        }
        WriteVerbose("Process end ... ");
    }
    protected override void EndProcessing()
    {
        WriteVerbose("End!");
    }
}
