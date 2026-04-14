$mainNav = @'
        <nav class="nav-buttons">
            <a href="index.html">Home</a>
            <a href="services.html">Services</a>
            <a href="students.html">Students</a>
            <a href="professionals.html">Professionals</a>
            <a href="about.html">About Us</a>
            <a href="contact.html">Contact</a>
        </nav>
'@

Get-ChildItem -Filter *.html | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 $path
    $regex = [regex] '(?s)(<div class="nav-strip">).*?(</div>)'
    $new = $regex.Replace($text, { param($m) $m.Groups[1].Value + "`r`n" + $mainNav + "`r`n    " + $m.Groups[2].Value })
    $new = $new -replace ([string]::Join('', [char]0xE2, [char]0x80, [char]0x94)), [char]0x2014
    $new = $new -replace ([string]::Join('', [char]0xE2, [char]0x80, [char]0x99)), [char]0x2019
    $new = $new -replace ([string]::Join('', [char]0xC3, [char]0x82, [char]0xC2, [char]0xA9)), [char]0x00A9
    $new = $new -replace ([string]::Join('', [char]0x53, [char]0xE2, [char]0x80, [char]0x91, [char]0x4C, [char]0x45, [char]0x54)), 'S-LET'
    $new = $new -replace ([string]::Join('', [char]0x53, [char]0xE2, [char]0x80, [char]0x91, [char]0x4C, [char]0x65, [char]0x74)), 'S-Let'
    $new = $new -replace ([string]::Join('', [char]0xC3, [char]0xA9)), [char]0x00E9
    $new = $new -replace ([string]::Join('', [char]0xC3, [char]0xA2)), [char]0x00E2
    $new = $new -replace ([string]::Join('', [char]0xC3, [char]0x82, [char]0xC2, [char]0xAB)), [char]0x00AB
    $new = $new -replace ([string]::Join('', [char]0xC3, [char]0x82, [char]0xC2, [char]0xBB)), [char]0x00BB
    if ($new -ne $text) {
        Set-Content -Path $path -Value $new -Encoding UTF8
        Write-Output "Updated $($_.Name)"
    }
}
Write-Output 'Top nav and mojibake cleanup completed.'
