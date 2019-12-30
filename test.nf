// PIPELINE TO TEST FEATURES OF THE NEXTFLOW LANGUAGE
//
/////////////////////
/// PROJECT SETUP ///
/////////////////////
//
// pipeline execution directory contains
/// nextflow.config
/// PIPELINE.nf
//
//////////////////
/// PARAMETERS ///
//////////////////
//
params.str = 'Hello world!'
//
//----------------------------------------------------------------------------//
//
/////////////////////////////////////
/// NEXTFLOW AND GROOVY SCRIPTING ///
/////////////////////////////////////


x = 1

println x

aList = [1432,-1,3]

println aList[0]

y = Math.random()
println y
if( y < 0.5 ) {
    println "Winner Winner"
    }
    else {
    print "Chicken Dinner"
    }
    
earlyter = "Early pipeline termination"

println "Error 5 " + earlyter + "\n"

multilineCmd = """ ls \
             grep a 
             """
result = multilineCmd.execute().text
println result

square = { it * it }
println square(9)
squareWow = [ 1, 2, 3, 4 ].collect(square)
println squareWow
project = params.project
project_dir = "~/repos/"+project 
//
//----------------------------------------------------------------------------//
////////////////////////////////////////
/// PIPELINE PROCESSES AND CHANNELS ////
////////////////////////////////////////
process checkProjectDirectory {
        """
        mkdir -p $project_dir/analysis/qc
        mkdir -p $project_dir/data/
        """
}
process splitLetters {

        output:
        file 'chunk_*' into letters

        """
        printf '${params.str}' | split -b 6 - chunk_
        """
}


process convertToUpper {

        input:
        file x from letters.flatten()

        output:
        stdout result

        """
        cat $x | rev 
        """
}


result.view { it.trim() }

process sayHellow {

        """
        echo 'Hellow world!'
        """

}
// use // to comment a single line or /* .. */ to comment a block on multiple 