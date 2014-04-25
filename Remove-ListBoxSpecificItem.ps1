function Remove-ListBoxSpecificItem
{
	PARAM (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListBox]$ListBox,
		[String]$Text
	)
	foreach ($item in $ListBox.Items)
	{
		IF ($item -like $Text)
		{
			$ListBox.Items.Remove($item)
		}
	}
}