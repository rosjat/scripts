using System.Text.Json.Serialization;

namespace RandomStuffModule.Cmdlet.HPiLo;

[JsonSourceGenerationOptions(WriteIndented = true)]
[JsonSerializable(typeof(HpIloEntry))]
internal partial class SourceGenerationContext : JsonSerializerContext
{

}
