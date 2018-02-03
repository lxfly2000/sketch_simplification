#要执行脚本，请在此文件上右键单击并选择“使用 PowerShell 运行”。
#To run this script, please right click on this file and choose "Run with PowerShell".

$webc = New-Object System.Net.WebClient

Function DownloadModel($url,$name,$hash)
{
	if(Test-Path "$PSScriptRoot\$name")
	{
		echo "$name 已存在。"
	}
	else
	{
		echo "下载 $name ..."
		$webc.DownloadFile($url,"$PSScriptRoot\$name")
	}
	if(!((Get-FileHash -Path $name -Algorithm MD5).Hash -eq $hash))
	{
		Write-Warning "下载的文件 $name 与服务器的文件不一致，建议重新下载。"
	}
}

DownloadModel "http://hi.cs.waseda.ac.jp/~esimo/data/sketch_mse.t7" "model_mse.t7" "12317df9a0a2a7220629f5f361b45b82"
DownloadModel "http://hi.cs.waseda.ac.jp/~esimo/data/sketch_gan.t7" "model_gan.t7" "3a5b4088f2490ca4b8140a374e80c878"
