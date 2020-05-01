#' SEIR factotum V2
#'
#' Solves a normalised (population=1) simplified SEIR system (no immunity loss, no mortality): 
#' 
#' 1_ extract the S, E, I, R, information from the input data P (positive) and R using the distributions IT, SRT, IBST. 
#'	The default distribution for IT is an exponential with rate 1/5.2 (5.2 being the mean Incubation Time)
#'		https://www.nejm.org/doi/full/10.1056/NEJMoa2001316
#'	The default distribution for SRT is an exponential with rate log(2)/5 (5 being the median time from symptomaticity to removal - hospitalisation)
#'		https://www.epicentro.iss.it/coronavirus/bollettino/Report-COVID-2019_13_aprile.pdf
#'	The default distribution for IBST is an none as no data is available
#'		
#' 2_ parameters sigma and gamma are estimated as 1/mean(IT) and 1/mean(SRT) resp
#'
#' 3_a if the user inputs a valid Rt (consisting of R0_msp and R0_stagesof length RN and RN-1 resp), SEIR_factotum will solve the multi-stage SEIR with 
#'	parameters (at n-th stage) sigma, gamma, beta[n]=Rt[n]*gamma. It will return U and sol, U being the refined data and sol being 
#'	the solution of the SEIR equation. 
#'
#' 3_b if no valid Rt is passed, SEIR_factotum will estimate an initial R0 using asymptotic properties of the series I in the early stages
#'	(from R0_exp_est_start to R0_exp_est_end, meaning R0 exponential estimate start/end), 
#'	then it will solve a single stage SEIR system with parameters sigma, gamma, beta=R0*gamma. 
#'	This can be used to show how the growth would have been like if no measures had taken place.
#'	It will return U and sol as above, plus result of the estimation of R0
#'	@export
####

# Example1: solve the SEIR for 10 days in the future, use normal distribution for IBST, 
# 			estimate the initial R0 up to day 4. 
# 			Retrieve the real data U, the solution sol, the estimated R0, info about R0. 
# 	
# 	out <- SEIR_factotum(P,R,N, future=10, distr_IBST='norm', par_IBST=list('mean'=2, 'std'=1), 
# 				R0_exp_est_end=4)
# 
# 	S<-out$S; E<-out$E; I<-out$I; R<-out$R
# 	S_<-out$S_; E_<-out$E_; I_<-out$I_; R_<-out$R_
# 	U <- list('S'=S, 'E'=E, 'I'=I, 'R'=R)
# 	sol <- list('S_'=S_, 'E_'=E_, 'I_'=I_, 'R_'=R_)
# 	
# 	R0<-out$R0; R0_time_start<-out$start; R0_time_end<-out$end; R0_fitting<-out$R0_fitting
# 	
# Example2: solve the SEIR up to data availability (that is, the length of the refined (S,E,I,R) 
# 		time series, in general less than the length of input time series P and R), 
# 		with one time fixed parameter R0_input (please note that R0_stages is required).
# 		Retrieve U and sol as above. 
# 
# 	out <- SEIR_factotum(P,R,N, future=0, R0_msp=R0_input, R0_stages=c())
# 	
# 	S<-out$S; E<-out$E; I<-out$I; R<-out$R
# 	S_<-out$S_; E_<-out$E_; I_<-out$I_; R_<-out$R_
# 	U <- list('S'=S, 'E'=E, 'I'=I, 'R'=R)
# 	sol <- list('S_'=S_, 'E_'=E_, 'I_'=I_, 'R_'=R_)
# 	
# Example3: solve the SEIR up to day 45 (20 S,E,I,R observations + 25 = future), 
# 		with a time varying parameter Rt, 
# 		Rt = 	8 from day 0 to day 5, 
# 				2 from day 5 to day 10, 
# 				4 from day 10 to day 20 (or in general up to the last observation)
# 				4 from day 20 to day 45 (the last value is used from day end to day end+future)
# 		Retrieve U and sol. 					
# 	
# 	Rt = c(8,2,4)
# 	R0_stages = c(5,10)
# 	
# 	out <- SEIR_factotum(P,R,N, future=25, end=20, R0_msp=Rt, R0_stages=c())
# 	
# 	S<-out$S; E<-out$E; I<-out$I; R<-out$R
# 	S_<-out$S_; E_<-out$E_; I_<-out$I_; R_<-out$R_
# 	U <- list('S'=S, 'E'=E, 'I'=I, 'R'=R)
# 	sol <- list('S_'=S_, 'E_'=E_, 'I_'=I_, 'R_'=R_)
# 	
SEIR_factotum <- function(P, R, N, end, normalise=TRUE, 
                          time_step=1, future=0,
                          distr_IT='exp', distr_SRT='exp', distr_IBST='none',
                          par_IT=list('rate'=1/5.2), par_SRT=list('rate'=log(2)/5), par_IBST=list(), 
                          R0_exp_est_start=1, R0_exp_est_end=5, R0_msp, R0_stages=c(), 
                          fit_Rt=FALSE, plot_data=TRUE) {
  
  #----Input Checking----
  if(length(R) < 5)
    stop('Not enough Removed data')
  if(length(P) < 5)
    stop('Not enough Positive data')
  
  #----"MACROS"----
  ERR_generation <- 'correct use : distr_X = \'exp\', par_X = list(\'rate\'=float) \tOR :  distr_X = \'norm\', par_X = list(\'mean\'=float, \'std\'=float\tOR : distr_X = \'none\''
  WARNING_end <- 'end > length(P). n_obs = min(end, length(P))'
  
  #----Functions----
  
  # Extract S, E, I, R from P, R. population is normalised to N=1
  refine_data <- function(P, R, IT, SRT, IBST, normalise=TRUE, end) {
    
    if(end<=length(P))
      n_obs <- end
    else {
      n_obs <- length(P)
      warning(WARNING_end)
    }
    
    m = max(length(IT), length(SRT), length(IBST))
    ITl = length(IT)
    SRTl = length(SRT)
    IBSTl = length(IBST)
    
    S = integer(n_obs-m)
    E = integer(n_obs-m)
    I = integer(n_obs-m)
    R = R[1:(n_obs-m)]
    
    for(t in (1:(n_obs-m))){
      IT_temp = c(IT, integer(n_obs-ITl-t+1))
      SRT_temp = c(SRT, integer(n_obs-SRTl-t+1))
      IBST_temp = c(IBST, integer(n_obs-IBSTl-t+1))
      
      E[t] <- ((IT_temp+SRT_temp)/2) %*% P[t:n_obs]
      I[t] <- ((IBST_temp+SRT_temp)/2) %*% P[t:n_obs]
    }
    
    S = N-E-I-R
    
    if(normalise){
      S = S/N
      E = E/N
      I = I/N
      R = R/N
    }
    
    return(data.frame(S, E, I, R))
    
  }
 
  # SEIR differential equations
  SEIR_model <- function(t, state, parameters){
    with(as.list(c(state, parameters)), {
      dS <- -beta*S*I
      dE <- beta*S*I-sigma*E
      dI <- sigma*E-gamma*I
      dR <- gamma*I
      
      list(c(dS, dE, dI, dR))
    })
  }
  # fit R0 optimising function distance d(U, U_) = sup(dist(U[t], U_[t]))
  ms_fit_R0 <- function(U0, U, par_fixed, L, time_step){
    
    target <- function(beta, sigma, gamma, U0, U, integration_extremes){
      dist <- function(X, Y) {
        if(length(X)==length(Y))
          out <- sqrt(as.numeric(sum((X-Y)^2)))
        else 
          out <- NULL
        return(out)
      }
      
      parameters <- list('beta'=beta, 'sigma'=sigma, 'gamma'=gamma)
      eval_time <- seq(0, (integration_extremes[2]-integration_extremes[1]))
      D <- c()
      # U in the time step we're considering, x+1 points. integration is performed on x+1 points from
      # 0 to Ln-L(n-1)
      U <- data.frame(U)
      Ut <- U[integration_extremes[1] + eval_time, ]
      
      U_ <- deSolve::ode(y=U0, times=eval_time, func=SEIR_model, parms=parameters)
      U_ <- data.frame(U_)
      colnames(U_) <- c('time', 'S_', 'E_', 'I_', 'R_')
      U_ <- U_[!(names(U_)=='time')]
      
      for(t in (1:length(Ut$S)))
        D[t] <- dist(Ut[t,], U_[t,])
      out <- max(D)
      
      return(out)
    }
    
    #---- Operations ----
    
    M <- length(L) # number of stages
    sigma <- par_fixed$sigma
    gamma <- par_fixed$gamma
    check <- FALSE #is this the last iteration? (ie from LM-1 to LM)
    
    opt_beta <- c()
    total <- data.frame() # solution from 0 to L[M]-1
    
    # at step n: 
    # find the interval of interest for ode (eval_time) and target(integration_extremes)
    # polish U0 in order to use it in further calculations
    # find the best parameter (opt_beta[n]) optimising target
    # solve (again) the ode with new_parms as parameters of SEIR_model, polihs solution
    # define initial data of stage n+1
    # drop the last element of solution n
    # save solution as stage n in total
    
    for(n in (1:M)){
      if(n==1){
        eval_time <- seq(0, L[1], by=time_step)
        integration_extremes <- c(0, L[1])
      }
      else {
        eval_time <- seq(0, L[n]-L[n-1], by=time_step) 
        integration_extremes <- c(L[n-1], L[n])
      }
      
      U0 <- as.numeric(U0)
      names(U0) <- c('S', 'E', 'I', 'R') # so that deSolve::ode can use appropriately the parameters
      
      opt_beta[n] <- stats::optimise(f=target, 
                                     sigma=sigma, gamma=gamma,
                                     U0=U0, U=U,
                                     integration_extremes=integration_extremes,
                                     interval=c(0,10))$minimum
      
      new_parms <- c(par_fixed, 'beta'=opt_beta[n])
      
      sol <- deSolve::ode(y=U0, times=eval_time, func=SEIR_model, parms=new_parms)
      sol <- data.frame(sol)	
      sol <- sol[!(names(sol)=='time')] # drop the time column
      
      if(n==1)
        U0 <- sol[L[n]+1,] 
      else	
        U0 <- sol[L[n]-L[n-1]+1,]
      
      if(n==1)
        total <- sol[-length(sol[[1]]),]
      else {
        if(n<M | future>1) # OR DROP ANYWAY?
          sol <- sol[-length(sol[[1]]),] 
        total <- rbind(total, sol) # append the new solution
      }	
    }
    
    rownames(total) <- 1:nrow(total)
    time <- seq(0, future*L[M], by=time_step) # the evaluation times for total
    names(total) <- c('S_', 'E_', 'I_', 'R_')
    out <- list('sol'=total, 'time'=time, 'beta'=opt_beta)
    return(out)
  }
  # Solve SEIR
  solve_SEIR <- function(U0, eval_time, parameters){
    state <- c('S'=U0[1], 'E'=U0[2], 'I'=U0[3], 'R'=U0[4])
    
    out <- deSolve::ode(y=state, times=eval_time, func=SEIR_model, parms=parameters)
    out <- data.frame(out)
    colnames(out) <- c('time', 'S_', 'E_', 'I_', 'R_')
    
    return(out)
  }
  # Solve multi stage SEIR
  solve_ms_SEIR <- function(U0, gamma, sigma, R0_msp, R0_stages, time_step){
    var_names <- list('S', 'E', 'I', 'R')
    par_fixed <- list('sigma'=sigma, 'gamma'=gamma)
    msp <- R0_msp*gamma
    L <- R0_stages
    
    ode <- multi_stage_ODE(U0, SEIR_model, var_names, par_fixed, msp, 'beta', L, time_step)
    sol <- ode$sol; time <- ode$time
    S_<-sol$S; E_<-sol$E; I_<-sol$I; R_<-sol$R
    
    out <- data.frame(time, S_, E_, I_, R_)
    colnames(out) <- c('time', 'S_', 'E_', 'I_', 'R_')
    
    return(out)
  }
  # Plotting, plotly. returns a plotly object
  plotty <- function(U, sol, name, plot_data=TRUE){
    S<-U$S; E<-U$E; I<-U$I; R<-U$R
    S_<-sol$S; E_<-sol$E; I_<-sol$I; R_<-sol$R
    
    x <- (1:length(S))
    x_ <- (1:length(S_))
    plotS <- FALSE
    
    # Should it print one graph or multiple? It depends: if S_ and E_ are comparable at some point, one graph is enough
    
    for(t in (1:length(S_)))
      if((S_<5*E_)[t])
        plotS <- TRUE
    
    trace_0 <- E
    trace_1 <- E_
    trace_2 <- I
    trace_3 <- I_
    trace_4 <- R
    trace_5 <- R_
    trace_6 <- S
    trace_7 <- S_
    
    colors <- c('r', 'b', 'g', 'y')
    
    
    df <- data.frame(x, trace_0, trace_2, trace_4, trace_6)
    df_ <- data.frame(x_, trace_1, trace_3, trace_5, trace_7)
    if(plotS){
      fig <- plotly::plot_ly()
      if(plot_data){
        fig <- fig %>% plotly::add_trace(df, x = ~x, y = ~trace_6, name = 'S', type = 'scatter', mode = 'markers', color=colors[1])
        fig <- fig %>% plotly::add_trace(df, x = ~x, y = ~trace_0, name = 'E', type = 'scatter', mode = 'markers', color=colors[2])
        fig <- fig %>% plotly::add_trace(df, x = ~x, y = ~trace_2, name = 'I', type = 'scatter', mode = 'markers', color=colors[3])
        fig <- fig %>% plotly::add_trace(df, x = ~x, y = ~trace_4, name = 'R', type = 'scatter', mode = 'markers', color=colors[4])
      }
      fig <- fig %>% plotly::add_trace(df_, x = ~x_, y = ~trace_7, name = 'S_', type = 'scatter', mode = 'lines', color=colors[1])
      fig <- fig %>% plotly::add_trace(df_, x = ~x_, y = ~trace_1, name = 'E_', type = 'scatter', mode = 'lines', color=colors[2])
      fig <- fig %>% plotly::add_trace(df_, x = ~x_, y = ~trace_3, name = 'I_', type = 'scatter', mode = 'lines', color=colors[3])
      fig <- fig %>% plotly::add_trace(df_, x = ~x_, y = ~trace_5, name = 'R_', type = 'scatter', mode = 'lines', color=colors[4])
      fig <- fig %>% plotly::layout(title = name)
      
    }
    else {
      
      fig1 <- plotly::plot_ly()
      if(plot_data){
        fig1 <- fig1 %>% plotly::add_trace(df, x = ~x, y = ~trace_0, name = 'E', type = 'scatter', mode = 'markers', color=colors[1])
        fig1 <- fig1 %>% plotly::add_trace(df, x = ~x, y = ~trace_2, name = 'I', type = 'scatter', mode = 'markers', color=colors[2])
        fig1 <- fig1 %>% plotly::add_trace(df, x = ~x, y = ~trace_4, name = 'R', type = 'scatter', mode = 'markers', color=colors[3])
      }
      fig1 <- fig1 %>% plotly::add_trace(df_, x = ~x_, y = ~trace_1, name = 'E_', type = 'scatter', mode = 'lines', color=colors[1])
      fig1 <- fig1 %>% plotly::add_trace(df_, x = ~x_, y = ~trace_3, name = 'I_', type = 'scatter', mode = 'lines', color=colors[2])
      fig1 <- fig1 %>% plotly::add_trace(df_, x = ~x_, y = ~trace_5, name = 'R_', type = 'scatter', mode = 'lines', color=colors[3])
      fig1 <- fig1 %>% plotly::layout(title = name)
      
      fig2 <- plot_ly()
      if(plot_data)
        fig2 <- fig2 %>% plotly::add_trace(df, x = ~x, y = ~trace_6, name = 'S', type = 'scatter', mode = 'markers', color=colors[4])
      fig2 <- fig2 %>% plotly::add_trace(df_, x = ~x_, y = ~trace_7, name = 'S_', type = 'scatter', mode = 'lines', color=colors[4])
      fig2 <- fig2 %>% plotly::layout(title = name)
      
      fig <- plotly::subplot(fig1, fig2)
      
    }
    return(fig)
  }
  
  #----Operations----
  
  # Generate distribution only up to 3rd quartile
  if(is.null(IT <- covid19::generate(distr_IT, par_IT)))	stop('ERROR in IT generation : ', ERR_generation)
  if(is.null(SRT <- covid19::generate(distr_SRT, par_SRT))) stop('ERROR in SRT generation : ', ERR_generation)
  if(is.null(IBST <- covid19::generate(distr_IBST, par_IBST))) stop('ERROR in IBST generation : ', ERR_generation)
  
  # Calculate sigma = 1/E[IT]. Calculate gamma = 1/E[IBST+SRT]
  sg_out<-calculate_sigma_gamma(IT, SRT, IBST); sigma<-sg_out$sigma; gamma<-sg_out$gamma
  
  # Extract S, E, I, R from P, R
  U<-refine_data(P, R, IT=IT, SRT=SRT, IBST=IBST, end=end, normalise=normalise); S<-U$S; E<-U$E; I<-U$I; R<-U$R
  
  # Initial conditions 
  U0 <- as.numeric(U[1,])
  
  # ALL GIVEN
  # elongate R0_stages if feasible (last element<length(S))
  # note that NOW R0_msp and R0_stages have the same length
  if(!missing(R0_msp)){
    
    if(length(R0_stages) > 0)
      if(R0_stages[length(R0_stages)] >= length(S))
        stop(sprintf('Each element of R0_stages has to be strictly < %i = length(S)', length(S)))
    R0_stages <- c(R0_stages, length(S))
    
    if(length(R0_msp)==length(R0_stages))
      M <- length(R0_msp) 
    else 
      stop('Error : length(R0_msp)!=length(R0_stages)-1')
    
    # add future stage (from Length(S) to future+Length(S))
    if(future>0){
      # add one more stage to Rt,  from R0_stages[M] to R0_stages[M]+future
      R0_msp[M+1] <- R0_msp[M]
      used_time <- c(R0_stages, (future+R0_stages[M]))
    }
    else
      used_time <- R0_stages
    
    sol <- solve_ms_SEIR(U0, gamma, sigma, R0_msp, used_time, time_step)
    
    out <- c(U, sol)
  }
  # Rt
  else if(fit_Rt){
    if(length(R0_stages) > 0)
      if(R0_stages[length(R0_stages)] >= length(S))
        stop(sprintf('Each element of R0_stages has to be strictly < %i = length(S)', length(S)))
    R0_stages <- c(R0_stages, length(S))
    
    if(future>0)
      used_time <- c(R0_stages, (future+R0_stages[M]))
    else
      used_time <- R0_stages
    
    sol <- list()
    par_fixed <- list('gamma'=gamma, 'sigma'=sigma)
    
    sol_Rt <- ms_fit_R0(U0, U, par_fixed, used_time, time_step)
    
    beta <- sol_Rt$beta
    Rt <- beta/gamma
    sol <- sol_Rt$sol
    
    out <- c(U, sol)
    out$Rt <- Rt
  }
  
  # R0
  else {
    
    R0_out <- estimate_R0(sigma, gamma, I, R0_exp_est_start, R0_exp_est_end); R0<-R0_out$R0
    
    beta <- R0*gamma
    eval_time <- seq(0, (future+length(U$I)-1), by = time_step)
    parameters <- c(beta=beta, sigma=sigma, gamma=gamma)
    
    sol <- solve_SEIR(U0, eval_time, parameters)
    
    # Returns SEIR, S_E_I_R_, time, R0, start (R0_time_start), end (R0_time_end), mean sq dist (mean_fitting)
    out <- c(U, sol, R0_out)
  }
  
  # Plot
  if(plot_data)
    name <- 'SEIR datapoints and solution'
  else
    name <- 'SEIR solution'
  
  # fig <- plotty(U, sol, name, plot_data)
  # out$plot <- fig
  
  return(out)
}