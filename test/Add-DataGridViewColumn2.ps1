function Add-DataGridViewColumn2
{
	PARAM (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.DataGridView]$DataGridView,
		[String[]]$ColumnName
	)
	
	foreach ($item in $ColumnName)
	{
		# Create Column object
		$Column = New-object -TypeName System.Windows.Forms.DataGridViewColumn
		$Column.HeaderText = $item
		$Column.Name = $item
		
		# Add the Column to the datagridview
		$DataGridView.Columns.AddRange($Column)
	}
}

