function Remove-ListBoxItems
{
	PARAM (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListBox]$ListBox
	)
	$ListBox.Items.Remove()
}