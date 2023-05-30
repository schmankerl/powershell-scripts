#Slightly modified version of Generate-GraphVisualization.ps1; Made to create node pairs from a file via regex matches
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

    # Read node pairs from the input file
    $nodePairs = Get-Content -Path $NodePairsFile | Where-Object { $_ -match "VALUES\(\d+,'(?<source>[^']+)','(?<target>[^']+)'"} | ForEach-Object { 
        $source = $matches["source"]
        $target = $matches["target"]
        "$source,$target"
    }

    # Split node list into separate arrays for the source and target nodes
    $sourceNodes = @()
    $targetNodes = @()
    foreach ($nodePair in $NodePairs) 
    {
        $sourceNode, $targetNode = $nodePair -split ","
        $sourceNodes += $sourceNode
        $targetNodes += $targetNode
    }

    # Create a list of unique nodes and edges from the source and target nodes
    $nodes = $sourceNodes + $targetNodes | Select-Object -Unique
    $edges = for ($i = 0; $i -lt $sourceNodes.Count; $i++) 
    {
        "$($sourceNodes[$i])->$($targetNodes[$i])"
    }

    # Create a new DOT file
    $dotFile = "graph.dot"
    @"
digraph G {
node [shape=box]
concentrate=true
rankdir=LR
ordering=out
$($nodes -join "`n")
$($edges -join "`n")
}
"@ | Set-Content -Path $dotFile

    # Generate a SVG image of the graph using GraphViz's dot.exe
    Start-Process -FilePath $env:DOT -ArgumentList "-Tsvg", $dotFile, "-O"
}

#Usage
# Generate-GraphVisualization -NodePairsFile "C:\path\to\node-pairs.txt"