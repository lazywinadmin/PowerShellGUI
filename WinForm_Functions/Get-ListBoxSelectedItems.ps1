function Get-ListBoxSelectedItems
{
	PARAM (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListBox]$ListBox
	)
	$ListBox.SelectedItems
}