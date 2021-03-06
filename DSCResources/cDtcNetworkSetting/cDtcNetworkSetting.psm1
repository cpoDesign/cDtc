Function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $True)]
        [System.String]$DtcName,

        [parameter(Mandatory = $True)]
        [System.Boolean]$RemoteClientAccessEnabled,

        [parameter(Mandatory = $True)]
        [System.Boolean]$RemoteAdministrationAccessEnabled,

        [parameter(Mandatory = $True)]
        [System.Boolean]$InboundTransactionsEnabled,

        [parameter(Mandatory = $True)]
        [System.Boolean]$OutboundTransactionsEnabled,

        [parameter(Mandatory = $True)]
        [ValidateSet("NoAuth","Incoming","Mutual")]
        [System.String]$AuthenticationLevel
    )

    Try {
        $CurrentDtc = Get-DtcNetworkSetting -DtcName $DtcName -ErrorAction Stop
    }
    Catch {
        Throw "Failed to get the network settings for the DtcName $DtcName"
    }

    $returnValue = @{
        DtcName = $DtcName
        RemoteClientAccessEnabled = $CurrentDtc.RemoteClientAccessEnabled
        RemoteAdministrationAccessEnabled = $CurrentDtc.RemoteAdministrationAccessEnabled
        InboundTransactionsEnabled = $CurrentDtc.InboundTransactionsEnabled
        OutboundTransactionsEnabled = $CurrentDtc.OutboundTransactionsEnabled
        AuthenticationLevel = $CurrentDtc.AuthenticationLevel
        LUTransactionsEnabled = $CurrentDtc.LUTransactionsEnabled
        XATransactionsEnabled = $CurrentDtc.XATransactionsEnabled
    }

    $returnValue
}

Function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $True)]
        [System.String]$DtcName,

        [parameter(Mandatory = $True)]
        [System.Boolean]$RemoteClientAccessEnabled,

        [parameter(Mandatory = $True)]
        [System.Boolean]$RemoteAdministrationAccessEnabled,

        [parameter(Mandatory = $True)]
        [System.Boolean]$InboundTransactionsEnabled,

        [parameter(Mandatory = $True)]
        [System.Boolean]$OutboundTransactionsEnabled,

        [parameter(Mandatory = $True)]
        [ValidateSet("NoAuth","Incoming","Mutual")]
        [System.String]$AuthenticationLevel,

        [System.Boolean]$LUTransactionsEnabled = $True,

        [System.Boolean]$XATransactionsEnabled = $False
    )

    $Params = @{
        DtcName=$DtcName
        RemoteClientAccessEnabled=$RemoteClientAccessEnabled
        RemoteAdministrationAccessEnabled=$RemoteAdministrationAccessEnabled
        InboundTransactionsEnabled=$InboundTransactionsEnabled
        OutboundTransactionsEnabled=$OutboundTransactionsEnabled
        AuthenticationLevel=$AuthenticationLevel
        LUTransactionsEnabled =$LUTransactionsEnabled
        XATransactionsEnabled=$XATransactionsEnabled
        Confirm=$False
        Verbose=$True
        ErrorAction="Stop"
    }

    Try {
        Set-DtcNetworkSetting @Params
    }
    Catch {
        Write-Error "An error occurred while configuring DTC instance $DtcName. Exception : $($_.Exception.Message)"
    }
}

Function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $True)]
        [System.String]$DtcName,

        [parameter(Mandatory = $True)]
        [System.Boolean]$RemoteClientAccessEnabled,

        [parameter(Mandatory = $True)]
        [System.Boolean]$RemoteAdministrationAccessEnabled,

        [parameter(Mandatory = $True)]
        [System.Boolean]$InboundTransactionsEnabled,

        [parameter(Mandatory = $True)]
        [System.Boolean]$OutboundTransactionsEnabled,

        [parameter(Mandatory = $True)]
        [ValidateSet("NoAuth","Incoming","Mutual")]
        [System.String]$AuthenticationLevel,

        [System.Boolean]$LUTransactionsEnabled = $True,

        [System.Boolean]$XATransactionsEnabled = $False
    )

    # Removing the bound parameters which are not supported by Get-TargetResource
    If ($PSBoundParameters.ContainsKey(‘LUTransactionsEnabled’)) {
        $PSBoundParameters.Remove('LUTransactionsEnabled’) | Out-Null
    }
    If ($PSBoundParameters.ContainsKey('XATransactionsEnabled')) {
        $PSBoundParameters.Remove('XATransactionsEnabled’) | Out-Null
    }

    $CurrentDtc = Get-TargetResource @PSBoundParameters

    [System.Boolean]$RemoteClientAccessEnabledTest = $CurrentDtc.RemoteClientAccessEnabled -eq $RemoteClientAccessEnabled
    Write-Verbose "Test of property RemoteClientAccessEnabled of DtcName $DtcName : $($RemoteClientAccessEnabledTest)"

    [System.Boolean]$RemoteAdministrationAccessEnabledTest = $CurrentDtc.RemoteAdministrationAccessEnabled -eq $RemoteAdministrationAccessEnabled
    Write-Verbose "Test of property RemoteAdministrationAccessEnabled of DtcName $DtcName : $($RemoteAdministrationAccessEnabledTest)"

    [System.Boolean]$InboundTransactionsEnabledTest = $CurrentDtc.InboundTransactionsEnabled -eq $InboundTransactionsEnabled
    Write-Verbose "Test of property InboundTransactionsEnabled of DtcName $DtcName : $($InboundTransactionsEnabledTest)"

    [System.Boolean]$OutboundTransactionsEnabledTest = $CurrentDtc.OutboundTransactionsEnabled -eq $OutboundTransactionsEnabled
    Write-Verbose "Test of property OutboundTransactionsEnabled of DtcName $DtcName : $($OutboundTransactionsEnabledTest)"

    [System.Boolean]$AuthenticationLevelTest = $CurrentDtc.AuthenticationLevel -eq $AuthenticationLevel
    Write-Verbose "Test of property AuthenticationLevel of DtcName $DtcName : $($AuthenticationLevelTest)"

    [System.Boolean]$LUTransactionsEnabledTest = $CurrentDtc.LUTransactionsEnabled -eq $LUTransactionsEnabled
    Write-Verbose "Test of property LUTransactionsEnabled of DtcName $DtcName : $($LUTransactionsEnabledTest)"

    [System.Boolean]$XATransactionsEnabledTest = $CurrentDtc.XATransactionsEnabled -eq $XATransactionsEnabled
    Write-Verbose "Test of property XATransactionsEnabled of DtcName $DtcName : $($XATransactionsEnabledTest)"

    $Result = $RemoteClientAccessEnabledTest -and $RemoteAdministrationAccessEnabledTest -and $InboundTransactionsEnabledTest -and $OutboundTransactionsEnabledTest -and $AuthenticationLevelTest -and $LUTransactionsEnabledTest -and $XATransactionsEnabledTest
    $Result
}

Export-ModuleMember -Function *-TargetResource