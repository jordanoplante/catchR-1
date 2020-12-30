##' get catch-at-age: return length frequencies and raw age-length keys
##' @param x output from get.samples
##' @param plus plus group age (numeric)
##' @details 
#'  Once catch of every level is diffused (get.sampled) by length and age class, this function calculates caa.
#'  So-called scores were added as an exploratory way to gauge the quality of the estimates each years.  
##' @importFrom reshape2 melt
##' @rdname get.caa
##' @export
get.caa <- function(x,plus=NULL){
    
    id.age <- grep('age\\.',colnames(x))
    
    # plus group
    if(!is.null(plus)){
        ages <- as.numeric(gsub('age.','',names(x)[id.age]))
        too.old <- ages>plus
        x[,max(id.age[!too.old])] <- rowSums(x[,id.age[too.old]])
        x[,id.age[too.old]] <- NULL
        id.age <- id.age[!too.old]
    }
    
    # calculations
    caa <- melt(x,id=names(x)[-id.age],variable.name='age',value.name='age.prop')
    caa$age <- as.numeric(gsub('age.','',caa$age))
    caa$caan <- with(caa,catch*age.prop*n.lf/(weight.sample.tot/10))
    caa$caaw <- with(caa,catch*age.prop*weight.sample/weight.sample.tot)
    caa <- do.call("rbind", as.list(
            by(caa,list(caa[,'year'],caa[,'age']),function(y){
                    wt=with(y,caaw/sum(caaw))
                    waa=weighted.mean(y$caaw/y$caan,wt)
                    waa.var=sum(wt * (y$weight.unit/10 - waa)^2)
                    data.frame(year=y$year[1],
                               age=y$age[1],
                               caan=sum(y$caan),
                               caaw=sum(y$caaw),
                               waa=waa,
                               waa.var=waa.var,
                               waa.sd=sqrt(waa.var),
                               score.lf.option=round(weighted.mean(y$option.lengthfreq,y$catch),2),
                               score.al.option=round(weighted.mean(y$option.agelength,y$catch),2),
                               score.lf.nsample=round(weighted.mean(y$nsample.lengthfreq,y$catch),2),
                               score.al.nsample=round(weighted.mean(y$nsample.agelength,y$catch),2))
                    })))

    return(caa)
}








