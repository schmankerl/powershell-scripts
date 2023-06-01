#Slightly modified version of Generate-GraphVisualization_custom.ps1; Adds colors and a legend for said colors, shows cost of edge if cost > 1
function Generate-GraphVisualization 
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory=$true, ParameterSetName="NodePairsFile")]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string]
        $NodePairsFile
    )

    # GraphViz X11 color scheme
    $colorPalette = @(
        "aqua", "darkgoldenrod4", "darkseagreen", "chartreuse", "hotpink",
        "red4", "chocolate4", "orangered", "darkorchid4",
        "mediumorchid", "salmon", "palevioletred"
    )

    # Read node pairs from the input file
    $nodePairs = Get-Content -Path $NodePairsFile | Where-Object { $_ -match "VALUES\(\d+,'(?<source>[^']+)','(?<target>[^']+)',(?<transport>\d+),(?<cost>\d+)," } | ForEach-Object { 
        $source = $matches["source"]
        $target = $matches["target"]
        $transport = $matches["transport"]
        $cost = [int]$matches["cost"]
        [PSCustomObject]@{
            Source = $source
            Target = $target
            Transport = $transport
            Cost = $cost
        }
    }

    # Split node list into separate arrays for the source and target nodes
    $sourceNodes = @()
    $targetNodes = @()
    $nodeColors = @{}
    $transportColors = @{}
    foreach ($nodePair in $nodePairs) 
    {
        $sourceNode = $nodePair.Source
        $targetNode = $nodePair.Target
        $sourceNodes += $sourceNode
        $targetNodes += $targetNode
        $transport = $nodePair.Transport
        if (-not $nodeColors.ContainsKey($sourceNode)) 
        {
            if (-not $transportColors.ContainsKey($transport)) 
            {
                $color = $colorPalette[$transportColors.Count % $colorPalette.Count]
                $transportColors[$transport] = $color
            }
            else 
            {
                $color = $transportColors[$transport]
            }
            $nodeColors[$sourceNode] = $color
        }
        if (-not $nodeColors.ContainsKey($targetNode)) 
        {
            if (-not $transportColors.ContainsKey($transport)) 
            {
                $color = $colorPalette[$transportColors.Count % $colorPalette.Count]
                $transportColors[$transport] = $color
            }
            else 
            {
                $color = $transportColors[$transport]
            }
            $nodeColors[$targetNode] = $color
        }
    }

    # Create a list of unique nodes and edges from the source and target nodes
    # enclose every node/edge in double quotes to prevent misbehavior because of special chars (-)
    $nodes = $sourceNodes + $targetNodes | Select-Object -Unique | ForEach-Object{
        "`"$_`""
    }
    $edges = foreach ($nodePair in $nodePairs) 
    {
        $sourceNode = $nodePair.Source
        $targetNode = $nodePair.Target
        $cost = $nodePair.Cost
        $transport = $nodePair.Transport
        $color = $transportColors[$transport]
        if ($cost -ne 1) 
        {
            "`"$sourceNode`"->`"$targetNode`" [label=`"Cost: $cost`", color=$color penwidth=2]"
        } else 
        {
            "`"$sourceNode`"->`"$targetNode`" [color=$color penwidth=2]"
        }
    }

    # Create a legend
    $legend = foreach ($transportColor in $transportColors.GetEnumerator()) 
    {
        $transportSystemID = $transportColor.Key
        $color = $transportColor.Value
        $legendColor = $color -replace "^\#", ""
        "Legend_$legendColor [shape=box, style=filled, fontcolor=black, color=$color, label=`"$transportSystemID : $color`"]"
    }

    # Create a new DOT file
    $dotFile = "graph.dot"
    @"
digraph G {
node [shape=box, style=filled, fontcolor=black]
concentrate=true
rankdir=LR
ordering=out
$($nodes -join "`n")
$($edges -join "`n")
$($legend -join "`n")
}
"@ | Set-Content -Path $dotFile

    # Generate an SVG image of the graph using GraphViz's dot.exe
    Start-Process -FilePath $env:DOT -ArgumentList "-Tsvg", $dotFile, "-O"
}

#Usage
# Generate-GraphVisualization -NodePairsFile "C:\path\to\node-pairs.txt"
