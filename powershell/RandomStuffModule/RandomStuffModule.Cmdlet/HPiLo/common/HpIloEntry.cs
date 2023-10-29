namespace RandomStuffModule.Cmdlet.HPiLo;

public class HpIloEntry
{
	public HpIloEntry() { }
	public string AssetTag { get; set; }
	public string BiosVersion { get; set; }
	public string Name { get; set; }
	public string Model { get; set; }
	public string Manufacturer { get; set; }
	public string HostName { get; set; }
	public string Description { get; set; }
	public string Id { get; set; }
	public string IndicatorLED { get; set; }
	public SystemStatus Status { get; set; }
	public string PowerState { get; set; }
	public ProcessorSummary ProcessorSummary { get; set; }
	public string SKU { get; set; }
	public string SerialNumber { get; set; }
	public string SystemType { get; set; }
	public string UUID { get; set; }
}
