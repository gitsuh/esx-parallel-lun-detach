Workflow detachluns {
	param
		(
			[string]$vcenter,
			[string]$session,
			$vmhosts,
			[string]$naaid
		)
	foreach -parallel($vmhost in $vmhosts){
		$result = InlineScript{
				Import-Module VMware.VimAutomation.Core
				Connect-VIServer -Server $Using:vcenter -Session $Using:session | Out-Null
				$vmh = get-vmhost $Using:vmhost
				#$vmh = get-vmhost $vmhost
				$scsiluns = $vmh |get-scsilun
				foreach($scsilun in $scsiluns){
					if($scsilun.canonicalname -eq $Using:naaid){
						$lunid = $scsilun.extensiondata.uuid
						$storsys = get-view $vmh.Extensiondata.Configmanager.storagesystem
						$storsys.DetachScsiLun($lunid);
					}
				}
		}
	}
}
$mycluster = "testing"
$myvmhosts = get-cluster $mycluster | get-vmhost
$naalist =(
"naa.blabla"
)
foreach($mynaaid in $naalist){
	detachluns -vmhosts $myvmhosts -naaid $mynaaid -vcenter $global:DefaultVIServer.Name -session $global:DefaultVIServer.SessionSecret
}
