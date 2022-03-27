# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}


### Update Help for Modules
Write-Host "Updating Help..." -ForegroundColor "Yellow"
Update-Help -Force


### Package Providers
Write-Host "Installing Package Providers..." -ForegroundColor "Yellow"
Get-PackageProvider NuGet -Force | Out-Null
# Chocolatey Provider is not ready yet. Use normal Chocolatey
#Get-PackageProvider Chocolatey -Force
#Set-PackageSource -Name chocolatey -Trusted


### Install PowerShell Modules
Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module Posh-Git -Scope CurrentUser -Force
Install-Module PSWindowsUpdate -Scope CurrentUser -Force


### Chocolatey
Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
if ((which cinst) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# system and cli
choco install curl                --limit-output
choco install nuget.commandline   --limit-output
choco install webpi               --limit-output
choco install git.install         --limit-output -params '"/GitAndUnixToolsOnPath /NoShellIntegration"'
choco install nvm.portable        --limit-output
choco install python              --limit-output

#fonts
choco install sourcecodepro       --limit-output

# browsers
choco install brave               --limit-output; <# pin; evergreen #> choco pin add --name Brave        --limit-output
choco install bitwarden-chrome    --limit-output

# apps
choco install 7zip                --limit-output
choco install spotify             --limit-output
choco install winscp              --limit-output
choco install procexp             --limit-output
choco install irfanview           --limit-output
choco install everything          --limit-output
choco install ffmpeg              --limit-output
choco install discord.install     --limit-output
choco install obs-studio.install  --limit-output
choco install wiztree             --limit-output
choco install sharex              --limit-output
choco install steam-client        --limit-output
choco install autodesk-fusion360  --limit-output
choco install dngrep              --limit-output
choco install streamdeck          --limit-output
choco install yt-dlp              --limit-output
choco install winmtr-redux        --limit-output

# dev tools and frameworks
choco install gitextensions       --limit-output
choco install vscode              --limit-output; <# pin; evergreen #> choco pin add --name VS Code      --limit-output
choco install vim                 --limit-output
choco install winmerge            --limit-output

Refresh-Environment

nvm on
$nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
nvm install $nodeLtsVersion
nvm use $nodeLtsVersion
Remove-Variable nodeLtsVersion

### Windows Features
Write-Host "Installing Windows Features..." -ForegroundColor "Yellow"

### Node Packages
Write-Host "Installing Node Packages..." -ForegroundColor "Yellow"
if (which npm) {
    npm update npm
    npm install -g gulp
    npm install -g mocha
    npm install -g node-inspector
    npm install -g yo
}

### Janus for vim
Write-Host "Installing Janus..." -ForegroundColor "Yellow"
if ((which curl) -and (which vim) -and (which rake) -and (which bash)) {
    curl.exe -L https://bit.ly/janus-bootstrap | bash
}

