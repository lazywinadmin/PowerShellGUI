function Get-ListBoxSelectedItems
{
	PARAM (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListBox]$ListBox,
		[switch]$Count
	)
	IF ($Count) { $ListBox.SelectedItems.Count }
	ELSE { $ListBox.SelectedItems }
}