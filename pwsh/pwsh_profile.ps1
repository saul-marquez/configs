oh-my-posh init pwsh --config "$PSScriptRoot/pwsh/prompt/cloud-context.omp.json" | Invoke-Expression

Import-Module posh-git


Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

[console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

New-Alias k kubectl

function l { eza -lAh }

function Load-Dotenv {
    param(
        [string]$path = ".env"
    )
    get-content $path | foreach {
        $name, $value = $_.split('=')
        set-content env:\$name $value
    }
}

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        dotnet complete --position $cursorPosition "$commandAst" | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}
Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $completion_file = New-TemporaryFile
    $env:ARGCOMPLETE_USE_TEMPFILES = 1
    $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    $env:_ARGCOMPLETE = 1
    $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
    $env:_ARGCOMPLETE_IFS = "`n"
    $env:_ARGCOMPLETE_SHELL = 'powershell'
    az 2>&1 | Out-Null
    Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
    Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

function Get-FileFromWeb {
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [string]$URL,

        # Parameter help description
        [Parameter(Mandatory)]
        [string]$File
    )
    Begin {
        function Show-Progress {
            param (
                # Enter total value
                [Parameter(Mandatory)]
                [Single]$TotalValue,

                # Enter current value
                [Parameter(Mandatory)]
                [Single]$CurrentValue,

                # Enter custom progresstext
                [Parameter(Mandatory)]
                [string]$ProgressText,

                # Enter value suffix
                [Parameter()]
                [string]$ValueSuffix,

                # Enter bar lengh suffix
                [Parameter()]
                [int]$BarSize = 40,

                # show complete bar
                [Parameter()]
                [switch]$Complete
            )

            # calc %
            $percent = $CurrentValue / $TotalValue
            $percentComplete = $percent * 100
            if ($ValueSuffix) {
                $ValueSuffix = " $ValueSuffix" # add space in front
            }
            if ($psISE) {
                Write-Progress "$ProgressText $CurrentValue$ValueSuffix of $TotalValue$ValueSuffix" -id 0 -percentComplete $percentComplete
            }
            else {
                # build progressbar with string function
                $curBarSize = $BarSize * $percent
                $progbar = ""
                $progbar = $progbar.PadRight($curBarSize,[char]9608)
                $progbar = $progbar.PadRight($BarSize,[char]9617)

                if (!$Complete.IsPresent) {
                    Write-Host -NoNewLine "`r$ProgressText $progbar [ $($CurrentValue.ToString("#.###").PadLeft($TotalValue.ToString("#.###").Length))$ValueSuffix / $($TotalValue.ToString("#.###"))$ValueSuffix ] $($percentComplete.ToString("##0.00").PadLeft(6)) % complete"
                }
                else {
                    Write-Host -NoNewLine "`r$ProgressText $progbar [ $($TotalValue.ToString("#.###").PadLeft($TotalValue.ToString("#.###").Length))$ValueSuffix / $($TotalValue.ToString("#.###"))$ValueSuffix ] $($percentComplete.ToString("##0.00").PadLeft(6)) % complete"
                }
            }
        }
    }
    Process {
        try {
            $storeEAP = $ErrorActionPreference
            $ErrorActionPreference = 'Stop'

            # invoke request
            $request = [System.Net.HttpWebRequest]::Create($URL)
            $response = $request.GetResponse()

            if ($response.StatusCode -eq 401 -or $response.StatusCode -eq 403 -or $response.StatusCode -eq 404) {
                throw "Remote file either doesn't exist, is unauthorized, or is forbidden for '$URL'."
            }

            if($File -match '^\.\\') {
                $File = Join-Path (Get-Location -PSProvider "FileSystem") ($File -Split '^\.')[1]
            }

            if($File -and !(Split-Path $File)) {
                $File = Join-Path (Get-Location -PSProvider "FileSystem") $File
            }

            if ($File) {
                $fileDirectory = $([System.IO.Path]::GetDirectoryName($File))
                if (!(Test-Path($fileDirectory))) {
                    [System.IO.Directory]::CreateDirectory($fileDirectory) | Out-Null
                }
            }

            [long]$fullSize = $response.ContentLength
            $fullSizeMB = $fullSize / 1024 / 1024

            # define buffer
            [byte[]]$buffer = new-object byte[] 1048576
            [long]$total = [long]$count = 0

            # create reader / writer
            $reader = $response.GetResponseStream()
            $writer = new-object System.IO.FileStream $File, "Create"

            # start download
            $finalBarCount = 0 #show final bar only one time
            do {

                $count = $reader.Read($buffer, 0, $buffer.Length)

                $writer.Write($buffer, 0, $count)

                $total += $count
                $totalMB = $total / 1024 / 1024

                if ($fullSize -gt 0) {
                    Show-Progress -TotalValue $fullSizeMB -CurrentValue $totalMB -ProgressText "Downloading $($File.Name)" -ValueSuffix "MB"
                }

                if ($total -eq $fullSize -and $count -eq 0 -and $finalBarCount -eq 0) {
                    Show-Progress -TotalValue $fullSizeMB -CurrentValue $totalMB -ProgressText "Downloading $($File.Name)" -ValueSuffix "MB" -Complete
                    $finalBarCount++
                    #Write-Host "$finalBarCount"
                }

            } while ($count -gt 0)
        }

        catch {

            $ExeptionMsg = $_.Exception.Message
            Write-Host "Download breaks with error : $ExeptionMsg"
        }

        finally {
            # cleanup
            if ($reader) { $reader.Close() }
            if ($writer) { $writer.Flush(); $writer.Close() }

            $ErrorActionPreference = $storeEAP
            [GC]::Collect()
        }
    }
}

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# powershell completion for kubectl                              -*- shell-script -*-

function __kubectl_debug {
    if ($env:BASH_COMP_DEBUG_FILE) {
        "$args" | Out-File -Append -FilePath "$env:BASH_COMP_DEBUG_FILE"
    }
}

filter __kubectl_escapeStringWithSpecialChars {
    $_ -replace '\s|#|@|\$|;|,|''|\{|\}|\(|\)|"|`|\||<|>|&','`$&'
}

[scriptblock]$__kubectlCompleterBlock = {
    param(
            $WordToComplete,
            $CommandAst,
            $CursorPosition
        )

    # Get the current command line and convert into a string
    $Command = $CommandAst.CommandElements
    $Command = "$Command"

    __kubectl_debug ""
    __kubectl_debug "========= starting completion logic =========="
    __kubectl_debug "WordToComplete: $WordToComplete Command: $Command CursorPosition: $CursorPosition"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CursorPosition location, so we need
    # to truncate the command-line ($Command) up to the $CursorPosition location.
    # Make sure the $Command is longer then the $CursorPosition before we truncate.
    # This happens because the $Command does not include the last space.
    if ($Command.Length -gt $CursorPosition) {
        $Command=$Command.Substring(0,$CursorPosition)
    }
    __kubectl_debug "Truncated command: $Command"

    $ShellCompDirectiveError=1
    $ShellCompDirectiveNoSpace=2
    $ShellCompDirectiveNoFileComp=4
    $ShellCompDirectiveFilterFileExt=8
    $ShellCompDirectiveFilterDirs=16
    $ShellCompDirectiveKeepOrder=32

    # Prepare the command to request completions for the program.
    # Split the command at the first space to separate the program and arguments.
    $Program,$Arguments = $Command.Split(" ",2)

    $RequestComp="$Program __complete $Arguments"
    __kubectl_debug "RequestComp: $RequestComp"

    # we cannot use $WordToComplete because it
    # has the wrong values if the cursor was moved
    # so use the last argument
    if ($WordToComplete -ne "" ) {
        $WordToComplete = $Arguments.Split(" ")[-1]
    }
    __kubectl_debug "New WordToComplete: $WordToComplete"


    # Check for flag with equal sign
    $IsEqualFlag = ($WordToComplete -Like "--*=*" )
    if ( $IsEqualFlag ) {
        __kubectl_debug "Completing equal sign flag"
        # Remove the flag part
        $Flag,$WordToComplete = $WordToComplete.Split("=",2)
    }

    if ( $WordToComplete -eq "" -And ( -Not $IsEqualFlag )) {
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __kubectl_debug "Adding extra empty parameter"
        # PowerShell 7.2+ changed the way how the arguments are passed to executables,
        # so for pre-7.2 or when Legacy argument passing is enabled we need to use
        # `"`" to pass an empty argument, a "" or '' does not work!!!
        if ($PSVersionTable.PsVersion -lt [version]'7.2.0' -or
            ($PSVersionTable.PsVersion -lt [version]'7.3.0' -and -not [ExperimentalFeature]::IsEnabled("PSNativeCommandArgumentPassing")) -or
            (($PSVersionTable.PsVersion -ge [version]'7.3.0' -or [ExperimentalFeature]::IsEnabled("PSNativeCommandArgumentPassing")) -and
              $PSNativeCommandArgumentPassing -eq 'Legacy')) {
             $RequestComp="$RequestComp" + ' `"`"'
        } else {
             $RequestComp="$RequestComp" + ' ""'
        }
    }

    __kubectl_debug "Calling $RequestComp"
    # First disable ActiveHelp which is not supported for Powershell
    $env:KUBECTL_ACTIVE_HELP=0

    #call the command store the output in $out and redirect stderr and stdout to null
    # $Out is an array contains each line per element
    Invoke-Expression -OutVariable out "$RequestComp" 2>&1 | Out-Null

    # get directive from last line
    [int]$Directive = $Out[-1].TrimStart(':')
    if ($Directive -eq "") {
        # There is no directive specified
        $Directive = 0
    }
    __kubectl_debug "The completion directive is: $Directive"

    # remove directive (last element) from out
    $Out = $Out | Where-Object { $_ -ne $Out[-1] }
    __kubectl_debug "The completions are: $Out"

    if (($Directive -band $ShellCompDirectiveError) -ne 0 ) {
        # Error code.  No completion.
        __kubectl_debug "Received error from custom completion go code"
        return
    }

    $Longest = 0
    [Array]$Values = $Out | ForEach-Object {
        #Split the output in name and description
        $Name, $Description = $_.Split("`t",2)
        __kubectl_debug "Name: $Name Description: $Description"

        # Look for the longest completion so that we can format things nicely
        if ($Longest -lt $Name.Length) {
            $Longest = $Name.Length
        }

        # Set the description to a one space string if there is none set.
        # This is needed because the CompletionResult does not accept an empty string as argument
        if (-Not $Description) {
            $Description = " "
        }
        @{Name="$Name";Description="$Description"}
    }


    $Space = " "
    if (($Directive -band $ShellCompDirectiveNoSpace) -ne 0 ) {
        # remove the space here
        __kubectl_debug "ShellCompDirectiveNoSpace is called"
        $Space = ""
    }

    if ((($Directive -band $ShellCompDirectiveFilterFileExt) -ne 0 ) -or
       (($Directive -band $ShellCompDirectiveFilterDirs) -ne 0 ))  {
        __kubectl_debug "ShellCompDirectiveFilterFileExt ShellCompDirectiveFilterDirs are not supported"

        # return here to prevent the completion of the extensions
        return
    }

    $Values = $Values | Where-Object {
        # filter the result
        $_.Name -like "$WordToComplete*"

        # Join the flag back if we have an equal sign flag
        if ( $IsEqualFlag ) {
            __kubectl_debug "Join the equal sign flag back to the completion value"
            $_.Name = $Flag + "=" + $_.Name
        }
    }

    # we sort the values in ascending order by name if keep order isn't passed
    if (($Directive -band $ShellCompDirectiveKeepOrder) -eq 0 ) {
        $Values = $Values | Sort-Object -Property Name
    }

    if (($Directive -band $ShellCompDirectiveNoFileComp) -ne 0 ) {
        __kubectl_debug "ShellCompDirectiveNoFileComp is called"

        if ($Values.Length -eq 0) {
            # Just print an empty string here so the
            # shell does not start to complete paths.
            # We cannot use CompletionResult here because
            # it does not accept an empty string as argument.
            ""
            return
        }
    }

    # Get the current mode
    $Mode = (Get-PSReadLineKeyHandler | Where-Object {$_.Key -eq "Tab" }).Function
    __kubectl_debug "Mode: $Mode"

    $Values | ForEach-Object {

        # store temporary because switch will overwrite $_
        $comp = $_

        # PowerShell supports three different completion modes
        # - TabCompleteNext (default windows style - on each key press the next option is displayed)
        # - Complete (works like bash)
        # - MenuComplete (works like zsh)
        # You set the mode with Set-PSReadLineKeyHandler -Key Tab -Function <mode>

        # CompletionResult Arguments:
        # 1) CompletionText text to be used as the auto completion result
        # 2) ListItemText   text to be displayed in the suggestion list
        # 3) ResultType     type of completion result
        # 4) ToolTip        text for the tooltip with details about the object

        switch ($Mode) {

            # bash like
            "Complete" {

                if ($Values.Length -eq 1) {
                    __kubectl_debug "Only one completion left"

                    # insert space after value
                    [System.Management.Automation.CompletionResult]::new($($comp.Name | __kubectl_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")

                } else {
                    # Add the proper number of spaces to align the descriptions
                    while($comp.Name.Length -lt $Longest) {
                        $comp.Name = $comp.Name + " "
                    }

                    # Check for empty description and only add parentheses if needed
                    if ($($comp.Description) -eq " " ) {
                        $Description = ""
                    } else {
                        $Description = "  ($($comp.Description))"
                    }

                    [System.Management.Automation.CompletionResult]::new("$($comp.Name)$Description", "$($comp.Name)$Description", 'ParameterValue', "$($comp.Description)")
                }
             }

            # zsh like
            "MenuComplete" {
                # insert space after value
                # MenuComplete will automatically show the ToolTip of
                # the highlighted value at the bottom of the suggestions.
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __kubectl_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }

            # TabCompleteNext and in case we get something unknown
            Default {
                # Like MenuComplete but we don't want to add a space here because
                # the user need to press space anyway to get the completion.
                # Description will not be shown because that's not possible with TabCompleteNext
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __kubectl_escapeStringWithSpecialChars), "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }
        }

    }
}

Register-ArgumentCompleter -CommandName 'kubectl' -ScriptBlock $__kubectlCompleterBlock
