function Get-ListBoxItems
{
	PARAM (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListBox]$ListBox,
		[switch]$Count
	)
	IF ($Count) { $ListBox.Items.Count }
	ELSE { $ListBox.Items}
}