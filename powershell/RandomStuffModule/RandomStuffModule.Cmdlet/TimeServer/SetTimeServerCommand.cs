using System;
using System.Management.Automation;


namespace RandomStuffModule.Cmdlet.TimeServer;

[Cmdlet(VerbsCommon.Set, "TimeServer")]
[OutputType(typeof(RegeditEntry))]
public class SetTimeServerCommand : PSCmdlet
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
    public string NewValue { get; set; }

    [Parameter(
        Position = 2,
        ValueFromPipelineByPropertyName = true)]
    public SwitchParameter Default { get; set; } = false;

    protected override void BeginProcessing()
    {
        WriteVerbose("Begin!");
    }
    protected override void ProcessRecord()
    {
        try
        {
            WriteObject(TimeServer.Set(ComputerName, NewValue, Default.IsPresent));
        }
        catch (Exception ex)
        {
            WriteObject(new ErrorRecord(ex, "EytryNotFound", ErrorCategory.InvalidData, ComputerName));
        }
    }
    protected override void EndProcessing()
    {
        WriteVerbose("End!");
    }
}
