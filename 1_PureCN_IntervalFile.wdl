workflow intervalfile {
	call IntervalFile
	
	call copy {
	    input:
    	    interval = IntervalFile.Interval 
	}
	
	meta {
		author: "Sehyun Oh"
        email: "shbrief@gmail.com"
        description: "IntervalFile.R of PureCN: Generate an interval file from a BED file containing baits coordinates"
    }
    
    output {
        File PureCN_interval = IntervalFile.Interval
    }
}

task IntervalFile {
	File inputBED
	File inputFasta
	String BED_pre = basename(inputBED, ".bed")
	File mappability

	command <<<
		Rscript /usr/local/lib/R/site-library/PureCN/extdata/IntervalFile.R \
		--infile ${inputBED} \
		--fasta ${inputFasta} \
		--outfile ${BED_pre}_gcgene.txt \
		--mappability ${mappability} \
		--force
	>>>

	runtime {
		docker: "quay.io/shbrief/pcn_docker"
		cpu : 4
		memory: "16 GB"
	}
	
	output {
		File Interval = "${BED_pre}_gcgene.txt"
	}
}

task copy {
    File interval
    String destination

    command {
        gsutil cp ${interval} ${destination}
    }

    runtime {
    	docker: "google/cloud-sdk:alpine"
    }
}