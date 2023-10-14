using System;
using System.Management.Automation;


namespace RandomStuffModule.Cmdlet.TimeServer;

[Cmdlet(VerbsCommon.Remove, "TimeServer")]
[OutputType(typeof(RegeditEntry))]
public class RemoveTimeServerCommand : PSCmdlet
{
    [Parameter(
        Mandatory = true,
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
        try
        {
            TimeServer.Remove(ComputerName);
            TimeServer.GetEntries().ForEach(e => WriteObject(e));
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