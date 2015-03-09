# #############################################################################
# NAME: AD-USER-Unlocker.ps1
#
# AUTHOR:	Francois-Xavier Cat
# DATE:		2013/03/22
# EMAIL:	fxcat@lazywinadmin.com
# WEBSITE:	LazyWinAdmin.com
# TWiTTER:	@lazywinadm
#
# COMMENT:  This script generate a GUI to unlock Active Directory
#           User Account.
#
# REQUIRE:  Permission to unlock account
# USAGE:    .\AD-USER-Unlocker.ps1
#
# VERSION HISTORY
# 1.0 2013.03.22 Initial Version.
#
# #############################################################################  

#----------------------------------------------
# GLOBAL SETTINGS
#----------------------------------------------
#  Set the Action Preference level
$ErrorActionPreference = "SilentlyContinue"
#----------------------------------------------

function OnApplicationLoad {
    return $true #return true for success or false for failure
}

function OnApplicationExit {
    $script:ExitCode = 0 #Set the exit code for the Packager
}

#----------------------------------------------
# Generated Form Function
#----------------------------------------------
function Call-Unlocker_pff {

    #----------------------------------------------
    #region Import the Assemblies
    #----------------------------------------------
    [void][reflection.assembly]::Load(`
	"mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
    [void][reflection.assembly]::Load(`
	"System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
    [void][reflection.assembly]::Load(`
	"System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
    [void][reflection.assembly]::Load(`
	"System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
    [void][reflection.assembly]::Load(`
	"System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
    [void][reflection.assembly]::Load(`
	"System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
    [void][reflection.assembly]::Load(`
	"System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
    [void][reflection.assembly]::Load(`
	"System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
    [void][reflection.assembly]::Load(`
	"System.ServiceProcess, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
    #endregion Import Assemblies

    #----------------------------------------------
    #region Generated Form Objects
    #----------------------------------------------
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $formUnlocker = New-Object 'System.Windows.Forms.Form'
    $statusbar1 = New-Object 'System.Windows.Forms.StatusBar'
    $listbox1 = New-Object 'System.Windows.Forms.ListBox'
    $buttonUnlock = New-Object 'System.Windows.Forms.Button'
    $buttonCheck = New-Object 'System.Windows.Forms.Button'
    $textbox1 = New-Object 'System.Windows.Forms.TextBox'
    $InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
    #endregion Generated Form Objects

    #----------------------------------------------
    # User Generated Script
    #----------------------------------------------

    $formUnlocker_Load={
    }
    
    #region Control Helper Functions
    function Load-ListBox 
    {
    <#
        .SYNOPSIS
            This functions helps you load items into a ListBox or CheckedListBox.
    
        .DESCRIPTION
            Use this function to dynamically load items into the ListBox control.
    
        .PARAMETER  ListBox
            The ListBox control you want to add items to.
    
        .PARAMETER  Items
            The object or objects you wish to load into the ListBox's Items 
			collection.
    
        .PARAMETER  DisplayMember
            Indicates the property to display for the items in this control.
        
        .PARAMETER  Append
            Adds the item(s) to the ListBox without clearing the Items collection.
        
        .EXAMPLE
            Load-ListBox $ListBox1 "Red", "White", "Blue"
        
        .EXAMPLE
            Load-ListBox $listBox1 "Red" -Append
            Load-ListBox $listBox1 "White" -Append
            Load-ListBox $listBox1 "Blue" -Append
        
        .EXAMPLE
            Load-ListBox $listBox1 (Get-Process) "ProcessName"
    #>
        Param (
            [ValidateNotNull()]
            [Parameter(Mandatory=$true)]
            [System.Windows.Forms.ListBox]$ListBox,
            [ValidateNotNull()]
            [Parameter(Mandatory=$true)]
            $Items,
            [Parameter(Mandatory=$false)]
            [string]$DisplayMember,
            [switch]$Append
        )
        
        if(-not $Append)
        {
            $listBox.Items.Clear()    
        }
        
        if($Items -is [System.Windows.Forms.ListBox+ObjectCollection])
        {
            $listBox.Items.AddRange($Items)
        }
        elseif ($Items -is [Array])
        {
            $listBox.BeginUpdate()
            foreach($obj in $Items)
            {
                $listBox.Items.Add($obj)
            }
            $listBox.EndUpdate()
        }
        else
        {
            $listBox.Items.Add($Items)    
        }
    
        $listBox.DisplayMember = $DisplayMember    
    }
    #endregion
    
    $buttonCheck_Click={
        
        # Get the Current text in $textbox1
        $name = $textbox1.Text
        
        # Search for this account in the current domain
        $Searcher = [ADSISearcher]"(sAMAccountName=$Name)"
        $Results = $Searcher.FindOne()
        
		# Get the current date and time
        $DateFormat = Get-Date -Format "yyyy/MM/dd-HH:mm:ss"
		
        if ($Results -ne $null){
            # If an Account is found do the following
        
            # Here we check the property "LockOutTime", if it is greater that 0
            # this mean the account is lockedout
            if($Results.properties.lockouttime -gt 0){
                # Show the information in the ListBox
                Load-ListBox `
					-ListBox $listBox1 `
					-Items "$DateFormat - $name - Account Locked Out" `
					-Append
            }else{
                # Show the information in the ListBox
                Load-ListBox `
					-ListBox $listBox1 `
					-Items "$DateFormat - $name - Account NOT Locked Out!" `
					-Append}
        }else {
            # Show the information in the ListBox
            Load-ListBox `
				-ListBox $listbox1 `
				-Items "$DateFormat - $name - Account Not Found!" `
				-Append}
    }
    
    $buttonUnlock_Click={
        
        # Get the Current text in $textbox1
        $name = $textbox1.Text
        
        # Search for this account in the current domain
        $Searcher = [ADSISearcher]"(sAMAccountName=$Name)"
        $Results = $Searcher.FindOne()
        
        if ($Results -ne $null){
            # If an Account is found do the following
            
            # Get the current date and time
            $DateFormat = Get-Date -Format "yyyy/MM/dd-HH:mm:ss"

            # Here we get Unlock the account
            $unlock = [ADSI]"$($Results.properties.adspath)"
            $unlock.Put("lockouttime",0)
            $unlock.SetInfo()
            
            # Show the information in the ListBox
            Load-ListBox `
				-ListBox $listBox1 `
				-Items "$DateFormat - $name - Account Unlocked!" `
				-Append
        }else {
            # Show the information in the ListBox
            Load-ListBox `
				-ListBox $listbox1 `
				-Items "$DateFormat - $name - Account Not Found!" `
				-Append}
    }#$buttonUnlock_Click
    
    $textbox1_TextChanged={
        # This part will check that the Textbox is not empty
        if ($textbox1.Text -eq "") {
            # If Empty, Back Color of the Textbox1 will be Red
            $textbox1.BackColor =  [System.Drawing.Color]::FromArgb(255, 128, 128);
            Load-ListBox `
				-ListBox $listbox1 `
				-Items "Please Enter an Account" `
				-Append
        }
        if ($textbox1.Text -ne "") {
            
            # If NOT Empty, Back Color of the Textbox1 will be Yellow
            $textbox1.BackColor =  [System.Drawing.Color]::FromArgb(255, 255, 192)
        }
            
            # In anycase, if the Textbox1 is empty, buttons will be disabled.
            $buttonCheck.Enabled = $textbox1.Text -ne ""
            $buttonLock.Enabled = $textbox1.Text -ne ""
            $buttonUnlock.Enabled = $textbox1.Text -ne ""
    }#$textbox1_TextChanged
    
    # --End User Generated Script--
    #----------------------------------------------
    #region Generated Events
    #----------------------------------------------
    
    $Form_StateCorrection_Load=
    {
        #Correct the initial state of the form to prevent the .Net maximized form issue
        $formUnlocker.WindowState = $InitialFormWindowState
    }
    
    $Form_Cleanup_FormClosed=
    {
        #Remove all event handlers from the controls
        try
        {
            $buttonUnlock.remove_Click($buttonUnlock_Click)
            $buttonCheck.remove_Click($buttonCheck_Click)
            $textbox1.remove_TextChanged($textbox1_TextChanged)
            $formUnlocker.remove_Load($formUnlocker_Load)
            $formUnlocker.remove_Load($Form_StateCorrection_Load)
            $formUnlocker.remove_FormClosed($Form_Cleanup_FormClosed)
        }
        catch [Exception]
        { }
    }
    #endregion Generated Events

    #----------------------------------------------
    #region Generated Form Code
    #----------------------------------------------
    #
    # formUnlocker
    #
    $formUnlocker.Controls.Add($statusbar1)
    $formUnlocker.Controls.Add($listbox1)
    $formUnlocker.Controls.Add($buttonUnlock)
    $formUnlocker.Controls.Add($buttonCheck)
    $formUnlocker.Controls.Add($textbox1)
    $formUnlocker.ClientSize = '450, 275'
    $formUnlocker.MaximumSize = '450, 314'
    $formUnlocker.Name = "formUnlocker"
    $formUnlocker.Text = "Unlocker"
    $formUnlocker.add_Load($formUnlocker_Load)
    #
    # statusbar1
    #
    $statusbar1.Location = '0, 253'
    $statusbar1.Name = "statusbar1"
    $statusbar1.Size = '260, 22'
    $statusbar1.TabIndex = 5
    $statusbar1.Text = "LazyWinAdmin.com - Francois-Xavier Cat"
    #
    # listbox1
    #
    $listbox1.Font = "Consolas, 9.75pt"
    $listbox1.FormattingEnabled = $True
    $listbox1.ItemHeight = 15
    $listbox1.Location = '12, 77'
    $listbox1.Name = "listbox1"
    $listbox1.Size = '415, 169'
    $listbox1.TabIndex = 4
    #
    # buttonUnlock
    #
    $buttonUnlock.Font = "Consolas, 12pt"
    $buttonUnlock.Location = '137, 48'
    $buttonUnlock.Name = "buttonUnlock"
    $buttonUnlock.Size = '113, 23'
    $buttonUnlock.TabIndex = 2
    $buttonUnlock.Text = "Unlock"
    $buttonUnlock.UseVisualStyleBackColor = $True
    $buttonUnlock.add_Click($buttonUnlock_Click)
    #
    # buttonCheck
    #
    $buttonCheck.Font = "Consolas, 12pt"
    $buttonCheck.Location = '12, 48'
    $buttonCheck.Name = "buttonCheck"
    $buttonCheck.Size = '114, 23'
    $buttonCheck.TabIndex = 1
    $buttonCheck.Text = "Check"
    $buttonCheck.UseVisualStyleBackColor = $True
    $buttonCheck.add_Click($buttonCheck_Click)
    #
    # textbox1
    #
    $textbox1.Font = "Microsoft Sans Serif, 14.25pt"
    $textbox1.Location = '12, 13'
    $textbox1.Name = "textbox1"
    $textbox1.Size = '238, 29'
    $textbox1.TabIndex = 0
    $textbox1.Text = "<SamAccountName>"
    $textbox1.add_TextChanged($textbox1_TextChanged)
    #endregion Generated Form Code

    #----------------------------------------------

    #Save the initial state of the form
    $InitialFormWindowState = $formUnlocker.WindowState
    #Init the OnLoad event to correct the initial state of the form
    $formUnlocker.add_Load($Form_StateCorrection_Load)
    #Clean up the control events
    $formUnlocker.add_FormClosed($Form_Cleanup_FormClosed)
    #Show the Form
    return $formUnlocker.ShowDialog()

} #End Function

#Call OnApplicationLoad to initialize
if((OnApplicationLoad) -eq $true)
{
    #Call the form
    Call-Unlocker_pff | Out-Null
    #Perform cleanup
    OnApplicationExit
}