
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
    cat("\nUsage: <file_list> <out.tsv>\n")
    cat("\n<file_list>   tsv containing the sample ID (col1) and the path of the \"groups.tsv\" (col2) generated by barcode-groups\n")
    cat("<out.tsv>     table containing the count for each GBC (as well as of their neighbors)\n\n")
    q()
}

FILE_LIST <- args[1]
OUT <- args[2]

file_list <- read.table(FILE_LIST, header = FALSE, sep = "\t")

# collect all GBCs
ALL_GBC <- lapply(file_list[,2], function(x) { 
                          df <- read.table(x, header = TRUE, sep = "\t")
                          as.character(df$hub) 
                       } 
                 )
ALL_GBC <- unique(unlist(ALL_GBC))

# initialize data frame
GBC_COUNT <- as.data.frame(matrix(0, nrow = length(ALL_GBC), ncol = nrow(file_list)))
rownames(GBC_COUNT) <- ALL_GBC
colnames(GBC_COUNT) <- file_list[,1]

# populate data frame
for (x in 1:nrow(file_list)) {
    id <- file_list[x,1]
    file <- file_list[x,2]
    df <- read.table(file, header = TRUE, sep = "\t")
    idx <- match(as.character(df$hub), ALL_GBC)
    GBC_COUNT[idx,x] <- df$group_count
}

# write to file
write.table(GBC_COUNT, file = OUT, sep = "\t", quote = FALSE)

q()

