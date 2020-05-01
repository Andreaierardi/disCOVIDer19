#' Multi-stage ODE
#' 
#' Solve an ODE with time-varying parameter msp (multi stage parameter) and time fixed parameters 
#' parameters. 
#' 
#' 
#' @param U0 named list. Initial conditions at time 0
#' @param func function. Given U array of variables, func(U;parameters) = dU/dt
#' @param var_names list of char. The names of the variable as in func
#' @param par_fixed named list. The format is ('name'=value)
#' @param msp array like. Contains all the values assumed by the time variable parameters
#' @param msp_name char. Name of the msp as appearing in func
#' @param L array like. Contains the extreme of use of the components of msp.	msp[n] is the msp in use from L[n-1] to L[n]. The last component of L is the final point of integration 
#' @param time_step float. Step of integration
#' 
#' @return a list:
#' \describe{
#' \item{sol}{dataframe. Solution to ODE evaluated at $times}
#' \item{time}{array like. Points of evaluation of solution}
#' }
#' 
#' @export
multi_stage_ODE <- function(U0, func, var_names, par_fixed, msp, msp_name, L, time_step){
  M <- length(L) # number of stages
  parms <- data.frame(par_fixed, msp) # parms[n, ] are the parameter to be used at stage n
  names(parms)[length(names(parms))] <- msp_name # msp will be referred with the passed name
  total <- data.frame() # solution from 0 to L[n]
  
  # at step n: 
  # find the interval of interest for deSolve::ode (eval_time) 
  # polish U0 in order to use it in further calculations
  # solve (again) the ode with new_parms as parameters of SEIR_model, polish solution
  # define initial data of stage n+1
  # drop the last element of solution n
  # save solution as stage n in total
  for(n in (1:M)){
    # print(sprintf('il resto : %i', n))
    # print(sprintf('L[n] = %i', L[n]))
    # print(sprintf('L[n-1] = %i', L[n-1]))
    # 
    if(n==1)
      eval_time <- seq(0, L[n], by=time_step)
    else
      eval_time <- seq(0, L[n]-L[n-1], by=time_step) 
    
    U0 <- as.numeric(U0)
    names(U0) <- var_names # so that deSolve::ode can use appropriately the parameters
    
    sol <- deSolve::ode(y=U0, times=eval_time, func=func, parms=parms[n,])
    sol <- data.frame(sol)	
    sol <- sol[!(names(sol)=='time')] # drop the time column
    
    # initial data of next stage
    if(n<M)
      if(n==1)
        U0 <- sol[L[n]+1,] 
    else	
      U0 <- sol[L[n]-L[n-1]+1,]
    
    # drop the last value in sol, as it is U0 for next stage. Avoid repetitions
    # if n==M, the last values should be dropped as well to have length(S)==length(S_)
    #
    if(n==1)
      total <- sol[-length(sol[[1]]),]
    else {
      sol <- sol[-length(sol[[1]]),] 
      total <- rbind(total, sol) # append the new solution
    }	
  }
  
  rownames(total) <- 1:nrow(total)
  time <- seq(0, L[M]-1, by=time_step) # the evaluation times for total
  out <- list('sol'=total, 'time'=time)
  
  return(out)
}