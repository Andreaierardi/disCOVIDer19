shinydashboard::tabItem(tabName = "tab_4",

                        
                        
                        shinydashboard::valueBox(
                          "Documentation",
                          "Authors, data source and documentation",
                          icon = icon("chart-bar"),
                          color = "red",
                          width = NULL
                        ),
                        
                        
                        shinydashboard::valueBox(
                          "Authors",
                          "Information",
                          icon = icon("chart-bar"),
                          color = "navy",
                          width = NULL
                        ),
                        
                        
                        shiny::fluidRow(
                          shiny::column(8,
                                        shinydashboard::box(width = 12,
                                                            status= "danger",
                                                            solidHeader = FALSE,
                                                            title = "Authors",
                                                            tags$head(tags$style(HTML('
                                                     /* tabBox background */
                                                     
                                                     .nav-tabs-custom > .nav-tabs > li.active {
                                                     border-top-color: red !important;
                                                     float:left;
                                                     }
                                                     
                                                     .btn-default {
                                                     background-color: #dd4b39 !important;
                                                     color: white !important;
                                                     border-color: #dd4b39 !important;
                                                     }
                                                     '))),
                                                            
                                                            shinydashboardPlus::userList(
                                                              shinydashboardPlus::userListItem(
                                                                src="https://avatars1.githubusercontent.com/u/36515398?s=460&u=152624d5b1720f1e66ffd3fbd43c6e13704c3e42&v=4",
                                                                user_name = "Andrea Ierardi",
                                                                description =HTML('<br> MSc. Data Science and Economics - Universita degli studi di Milano <br>  BC. in Computer Science <br> Universita del Piemonte orientale(UPO) <br><br> 
                                                       <a href="https://www.linkedin.com/in/andreaierardi/" rel="nofollow noreferrer">
                                                       <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn</a> &nbsp; 
                                                       <a href="https://github.com/Andreaierardi" rel="nofollow noreferrer">
                                                      <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github</a> <br> 
                                                      <a href="https://ierardiandrea.com/" rel="nofollow noreferrer">
                                                      <i class="fas fa-cloud"></i> Website  </a> ')
                                                              ),
                                                              
                                                              shinydashboardPlus::userListItem(
                                                                src="https://avatars3.githubusercontent.com/u/59971032?s=400&u=38395af942e20f0c9a395b2b30b12763a39ca8ac&v=4",
                                                                user_name = "Gregorio Saporito",
                                                                description =HTML(' <br>  MSc. Data Science and Economics (UNIMI) <br> 
                                                       Master of International Business (The University of Auckland) <br> 
                                                       BC. in Business and Economics (Bocconi) <br> 
                                                       <br><a href="https://www.linkedin.com/in/greg-saporito/" rel="nofollow noreferrer">
                                                       <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn</a>  &nbsp;
                                                       <a href="https://github.com/gregorio-saporito" rel="nofollow noreferrer"> 
                                                       <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp; '
                                                                )),
                                                              shinydashboardPlus::userListItem(
                                                                src="https://avatars3.githubusercontent.com/u/60003802?s=460&u=6463f4db28ebb1eaf463f117093a803af1b9cabc&v=4",
                                                                user_name = "Marzio De Corato",
                                                                description =HTML('<br>M.Sc. Data Science and Economics student (UNIMI) <br> Ph.D in Physics and Nanoscience (UNIMORE), M.Sc. in Physics (UNIMIB) (theoretical-computational solid state physics)<br><br>
                                                     <a href="https://www.linkedin.com/in/marzio-de-corato-2351a44b/" rel="nofollow noreferrer">
                                  <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn </a>  &nbsp;
                                  <a href="https://github.com/marzione00" rel="nofollow noreferrer"> 
                                  <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp; 
                                                    
                                                    ')
                                                              )
                                                            ),
                                                            br(),
                                                            
                                                            shinydashboardPlus::userList(
                                                              shinydashboardPlus::userListItem(
                                                                src="https://media-exp1.licdn.com/dms/image/C4D03AQFNxDX9vdxEmQ/profile-displayphoto-shrink_800_800/0?e=1590019200&v=beta&t=ftXpX3Wg-dB2t8sBoSYspTKC3z5cK2ehYhWk5obIBh4",
                                                                user_name = "Fabio Caironi",
                                                                description = HTML('<br>
                                                                BC. in Mathematics. <br>
                                                                MSc. student of Data Science and Economics <br>
                                                                Piano student at Conservatorio G. Verdi in Milan
                                                       <br><br>
                                                      <a href="https://www.linkedin.com/in/fabio-caironi-8361091a2/" rel="nofollow noreferrer">
                                                      <img src="https://i.stack.imgur.com/gVE0j.png" alt="linkedin"> LinkedIn</a>  &nbsp;
                                                      <a href="https://github.com/fabio130497" rel="nofollow noreferrer"> 
                                                      <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp; 
                                                       '
                                                                                   
                                                                )),
                                                              
                                                              
                                                              
                                                              shinydashboardPlus::userListItem(
                                                                src="https://avatars0.githubusercontent.com/u/59998291?s=460&v=4",
                                                                user_name = "Federico Matteucci",
                                                                description = HTML (' <br> M.Sc. Data Science and Economics - UNIMI;<br> Bachelor in Mathematics - UNIMI
                                                                <br><br><a href="https://github.com/De-Rham-Cohomology" rel="nofollow noreferrer"> 
                                                       <img src="https://i.stack.imgur.com/tskMh.png" alt="github"> Github </a> &nbsp;')
                                                              ),
                                                            )
                                        )
                          ),
                          shiny::column(4,
                                        shinydashboard::box(width = 12,
                                                            status= "danger",
                                                            solidHeader = FALSE,
                                                            title = "Data source",
                                                            
                                                            br(),
                                                            h2("Reference"),
                                                            hr(),
                                                            
                                                            HTML('<ul>
                                                            <li> <h4> <a href="https://github.com/pcm-dpc/COVID-19" rel="nofollow noreferrer">  Protezione Civile - General information  </a> </h4> </li>
                                                            
                                                            <li><h4>  <a href="http://dati.istat.it/Index.aspx?DataSetCode=DCIS_POPRES1">  Istat - Population  </a> </h4> </li>                                                                                                                           
                                                            <li><h4>  <a href="https://www.istat.it/it/files//2015/04/Superfici-delle-unit%C3%A0-amministrative-Dati-comunali-e-provinciali.zip">  Istat - Territory </a> </h4> </li>
                                                            <li><h4>  <a href="https://www.corriere.it/cronache/20_marzo_16/coronavirus-quanti-posti-terapia-intensiva-ci-sono-italia-quanti-ne-arriveranno-0fbafa76-678a-11ea-93a4-da8ab3a8afb1.shtml" rel="nofollow noreferrer">   Corriere.it - Hospital intensive care capacity </a>  </h4></li>
                                                            <li><h4>  <a href="https://www.epicentro.iss.it"> Istituto superiore di Sanita\' - Age distribution report </a> </h4> </li>

                                                            </ul>
                                                                 ')
                                        )
                                        
                          )
                          
                        ),
                        
                        br(),
                        
                        shinydashboard::valueBox(
                          "Documentation",
                          "A navigator within the pandemia",
                          icon = icon("chart-bar"),
                          color = "navy",
                          width = NULL
                        ),
                        
                        shiny::fluidRow(
                          shiny::column(12,
                                        shinydashboard::box(width = 12,
                                                            status= "danger",
                                                            solidHeader = FALSE,
                                                            title = "Documentation",
                                                            br(),
                                                            h3("To be completed.."),
                                                            
                                                            downloadButton("downloadDocument", label = "Download the PDF" ),
                                                            hr(),
                                                            htmlOutput("pdfview")
                                        ))
                        )

)
