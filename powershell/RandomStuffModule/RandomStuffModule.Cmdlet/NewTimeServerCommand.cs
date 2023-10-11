using Microsoft.Win32;
using System.Linq;
using System.Management.Automation;


namespace RandomStuffModule.Cmdlet
{
    [Cmdlet(VerbsCommon.New,"TimeServer")]
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
        private string registryKeyString ;
        // This method gets called once for each cmdlet in the pipeline when the pipeline starts executing
        protected override void BeginProcessing()
        {
            //HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers
            registryKeyString = @"SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers";
            WriteVerbose("Begin!");
            WriteVerbose($"opening {registryKeyString}");
        }

        // This method will be called for each input received from the pipeline to this cmdlet; if no input is received, this method is not called
        protected override void ProcessRecord()
        {
            using(var key = Registry.LocalMachine.OpenSubKey(registryKeyString, RegistryKeyPermissionCheck.ReadWriteSubTree))
            {
                int oldKeyCount = key.ValueCount;

                key.SetValue(oldKeyCount.ToString(),ComputerName);
                if(Default.IsPresent)
                    key.SetValue(key.GetValueNames().First(),oldKeyCount.ToString());
                WriteObject(new RegeditEntry { 
                    Name = oldKeyCount,
                    Value = ComputerName,
                    Default = Default.IsPresent
                });

            }
        }

        // This method will be called once at the end of pipeline execution; if no input is received, this method is not called
        protected override void EndProcessing()
        {
            WriteVerbose("End!");
        }
    }

    public class RegeditEntry
    {
        public int Name { get; set; }
        public string Value { get; set; }
        public bool Default { get; set; }
    }
}
