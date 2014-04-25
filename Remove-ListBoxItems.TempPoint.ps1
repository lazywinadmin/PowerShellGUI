function Remove-ListBoxItems
{
	PARAM (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListBox]$ListBox
	)
	$ListBox.BeginUpdate()
	$ListBox.Items.Clear()
	$ListBox.EndUpdate()
}