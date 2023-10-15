using System;
using Microsoft.Win32;
using System.Management.Automation;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace RandomStuffModule.Cmdlet;

[Cmdlet(VerbsData.Export, "PuttySetting", DefaultParameterSetName = "All")]
[OutputType(typeof(RegistryEntry))]
public class WxportPuttySettingCommand : PSCmdlet
{
	[Parameter(
		Position = 0,
		ValueFromPipeline = true,
		ValueFromPipelineByPropertyName = true)]
	public string Output { get; set; } = $"{Environment.GetFolderPath(Environment.SpecialFolder.Desktop)}\\putty.reg";
	[Parameter(ParameterSetName = "JumpList")]
	public SwitchParameter JumpList { get; set; } = false;

	[Parameter(ParameterSetName = "Sessions")]
	public SwitchParameter Sessions { get; set; } = false;

	[Parameter(ParameterSetName = "HostKeys")]
	public SwitchParameter HostKeys { get; set; } = false;

	[Parameter(ParameterSetName = "All")]
	public SwitchParameter All { get; set; } = false;

	private readonly string registryBaseKeyString = @"Software\\SimonTatham\\PuTTY";
	protected override void BeginProcessing()
	{
		WriteVerbose("Begin!");
	}
	protected override void ProcessRecord()
	{
		WriteVerbose(ParameterSetName);
		switch (ParameterSetName)
		{
			case "All":
				CreateRegistryFile(Output, string.Empty);
				break;
			case "JumpList":
				CreateRegistryFile(Output, "\\Jumplist");
				break;
			case "Sessions":
				CreateRegistryFile(Output, "\\Sessions");
				break;
			case "HostKeys":
				CreateRegistryFile(Output, "\\SshHostkeys");
				break;
		}

	}
	protected override void EndProcessing()
	{
		WriteVerbose("End!");
	}
	private StringBuilder ConvertMultiStingToHex(RegistryEntry entry)
	{
		StringBuilder sb = new();
		var linebreak = 80;
		var counter = 25;
		foreach (var line in entry.Value as string[])
		{

			var foo = Encoding.Unicode.GetBytes(line + "\0");
			foreach (var c in foo)
			{

				if (counter >= linebreak - 3)
				{
					sb.Append($"\\{Environment.NewLine}  ");
					counter = 2;
				}
				sb.Append($"{c.ToString("x2")},");
				counter += 3;

			}
		}
		sb.Append($"00,00");
		return sb;
	}
	private string ConvertDwordToHex(RegistryEntry entry)
	{
		return Convert.ToInt32(entry.Value).ToString("X8");
	}
	private void CreateRegistryFile(string filename, string registryKeyString)
	{
		try
		{
			Dictionary<string, List<RegistryEntry>> dict = new();
			CreateExportDict(ref dict, $"{registryBaseKeyString}{registryKeyString}");
			StringBuilder sb = new();
			sb.AppendLine("Windows Registry Editor Version 5.00");
			sb.AppendLine(Environment.NewLine);
			foreach (var entry in dict)
			{

				sb.AppendLine($"[{entry.Key}]");
				entry.Value.ForEach((e) =>
				{
					switch (e.Type)
					{
						case RegistryValueKind.MultiString:
							sb.AppendLine($"\"{e.Name}\"=hex(7):{ConvertMultiStingToHex(e).ToString()}");
							break;
						case RegistryValueKind.DWord:
							sb.AppendLine($"\"{e.Name}\"={e.Type.ToString().ToLower()}:{ConvertDwordToHex(e).ToString()}");
							break;
						case RegistryValueKind.String:
							sb.AppendLine($"\"{e.Name}\"=\"{e.Value}\"");
							break;
					}
				});
				sb.AppendLine(Environment.NewLine);
			}
			using var f = new StreamWriter(Output);
			f.WriteLine(sb.ToString());
		}
		catch (System.Exception ex)
		{
			WriteError(new ErrorRecord(ex, "CreateRegistyFile", ErrorCategory.NotSpecified, registryKeyString));
			throw;
		}
	}
	private void CreateExportDict(ref Dictionary<string, List<RegistryEntry>> dict, string regKeyString)
	{
		using RegistryKey baseKey = RegistryKey.OpenBaseKey(RegistryHive.CurrentUser, RegistryView.Registry32);
		using RegistryKey key = baseKey.OpenSubKey(regKeyString, RegistryKeyPermissionCheck.ReadWriteSubTree);
		var keyNames = key.GetValueNames();
		dict.Add(key.Name, new());
		foreach (var name in keyNames)
		{
			dict[key.Name].Add(new RegistryEntry()
			{
				Name = name,
				Type = key.GetValueKind(name),
				Value = key.GetValue(name)
			});
		}
		if (key.SubKeyCount > 0)
		{
			var subKeyNames = key.GetSubKeyNames();
			foreach (var subKey in subKeyNames)
			{
				var parts = key.Name.Split("\\");
				CreateExportDict(ref dict, $"{string.Join("\\", parts[1..])}\\{subKey}");
			}
		}
	}
	internal class RegistryEntry
	{
		public string Name { get; set; }
		public RegistryValueKind Type { get; set; }
		public object Value { get; set; }
	}
}
