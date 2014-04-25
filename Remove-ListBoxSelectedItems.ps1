function Remove-ListBoxSelectedItems
{
	PARAM (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListBox]$ListBox
	)
	$ListBox.BeginUpdate()
	while ($ListBox.SelectedItems -gt 0)
	{
		foreach ($item in $ListBox.SelectedItems)
		{
			$ListBox.Items.Remove($item)
		}
	}
	$ListBox.EndUpdate()
}