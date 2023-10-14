using System.Management.Automation;


namespace RandomStuffModule.Cmdlet.TimeServer;

[Cmdlet(VerbsCommon.New, "TimeServer")]
[OutputType(typeof(RegeditEntry))]
public class NewTimeServerCommand : PSCmdlet
{
    [Parameter(
        Mandatory = true,
        Position = 0,
        ValueFromPipeline = true,
        ValueFromPipelineByPropertyName = true)]
    public string ComputerName { get; set; }

    [Parameter(
        Position = 1,
        ValueFromPipelineByPropertyName = true)]
    public SwitchParameter Default { get; set; } = false;

    protected override void BeginProcessing()
    {
        WriteVerbose("Begin!");
    }
    protected override void ProcessRecord()
    {
        WriteObject(TimeServer.Add(ComputerName, Default.IsPresent));
    }
    protected override void EndProcessing()
    {
        WriteVerbose("End!");
    }
}

