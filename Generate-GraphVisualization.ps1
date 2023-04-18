#Function which takes nodes in a comma seperated list as input and then outputs a .png file with the help of GraphViz
#Needs to have $env:DOT set to the path of GraphViz dot.exe
function Generate-GraphVisualization 
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory=$true, ParameterSetName="NodePairs")]
        [string[]]
        $NodePairs,

        [Parameter(Mandatory=$true, ParameterSetName="NodePairsFile")]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string]
        $NodePairsFile
    )

    # Read the node pairs from the input file, if provided
    if ($PSCmdlet.ParameterSetName -eq "NodePairsFile") 
    {
        $NodePairs = Get-Content -Path $NodePairsFile
    }

    # Split the node list into separate arrays for the source and target nodes
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
    ordering="out"
    $($nodes -join "`n")
    $($edges -join "`n")
}
"@ | Set-Content -Path $dotFile

    # Generate a PNG image of the graph using GraphViz's dot.exe
    Start-Process -FilePath $env:DOT -ArgumentList "-Tsvg", $dotFile, "-O"
}

#Usage
# Generate-GraphVisualization -NodePairs "A,B", "B,C", "C,D"
# Generate-GraphVisualization -NodePairsFile "C:\path\to\node-pairs.txt"