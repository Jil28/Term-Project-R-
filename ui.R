shinyUI(dashboardPage(
  skin = "blue",
  dashboardHeader(title = strong('Boston Crime')),
  dashboardSidebar(
    #sidebar
    sidebarMenu(
      menuItem('About', tabName = 'about', icon = icon('clipboard')),
      menuItem('Map', tabName = 'map' , icon = icon('map')),
      menuItem(
        'Time Series',
        tabName = 'time',
        icon = icon('chart-line')
      ),
      menuItem(
        'Word Cloud',
        tabName = 'word',
        icon = icon('cloudversify')
      ),
      #create link tab for code
      menuItem('Link to the code',
               href = 'https://github.com/Jil28/R-Term-Project',
               icon = icon('code'))
    )
  ),
  
  dashboardBody(tabItems(
    #create tab about
    tabItem(
      tabName = 'about',
      fluidRow(column(
        width = 12,
        align = 'center',
        box(
          title = strong('Boston Crime'),
          status = 'primary',
          solidHeader = T,
          width = NULL,
          img(src = "https://www.deccanherald.com/sites/dh/files/articleimages/2022/07/14/crime-scene-istock-1123244-1656810126-1126478-1657746040.jpg",
              width = 800, align = "center")
        )
      )),
      fluidRow(column(
        width = 12,
        box(
          title = strong('Context'),
          status = 'primary',
          solidHeader = T,
          width = NULL,
          h4(
            'This is a dataset containing records from the new crime incident report system, which includes a reduced set of fields focused on capturing the type of incident as well as when and where it occurred.'
          )
        )
      )),
      fluidRow(column(
        width = 12,
        box(
          title = strong('Data'),
          status = 'primary',
          solidHeader = T,
          width = NULL,
          h4('The dataset utilized in this application is from Kaggle. Which was originally provided by the Boston Police Department. The dataset contains records from the new crime incident report system, which includes a reduced number of fields focusing on documenting the type of occurrence as well as when and where it occurred. The dataset itself has 2,60,760 rows and 17 columns. I concentrated my efforts in three areas: time, location, and crime type.')
        )
      )),
      fluidRow(column(
        width = 12,
        box(
          title = strong('App Info'),
          status = 'primary',
          solidHeader = T,
          width = NULL,
          h4('The application consists of total five tabs which are About, Map, Time Series, Word Cloud, and Link to profile. Each tab contains different information in different presentations. About is the home page for this application which states the information about the dataset porpoise of the project. If we talk about map and time series, they contain interactive visualizations which are created with Boston city crime data. Link to Profile tab directly connected with my GitHub profile.'),
        )
      )),
    ),
    #create tab map
    tabItem(tabName = 'map',
            fluidRow(column(
              width = 12,
              box(
                title = 'Crime Analysis',
                status = 'primary',
                solidHeader = T,
                infoBoxOutput("maxBox"),
                infoBoxOutput("minBox"),
                infoBoxOutput("avgBox"),
                width = NULL
              )
            )),
            fluidRow(
              column(
                width = 6,
                box(
                  title = 'Select Input',
                  status = 'primary',
                  solidHeader = T,
                  selectInput(
                    "year",
                    label = strong("Select Year to Display"),
                    choices = unique(dist$year),
                    selected = 1
                  ),
                  checkboxInput('shoot', strong('Shooting?'), value = F),
                  width = NULL
                ),
                box(
                  title = 'Crime Rate by Time',
                  status = 'primary',
                  solidHeader = T,
                  leafletOutput('mymap1'),
                  width = NULL
                )
              ),
              column(
                width = 6,
                box(
                  title = 'Select District to Inspect',
                  status = 'primary',
                  solidHeader = T,
                  width = NULL,
                  selectInput(
                    "district_map",
                    label = strong("Choose a District"),
                    choices = as.character(unique(dist$district)),
                    selected = as.character(unique(dist$district))[1]
                  ),
                  checkboxInput('inspect', strong('Inspect Which Area?'), value = F)
                ),
                box(
                  title = 'Crime Rate by Time Data Table',
                  status = 'primary',
                  solidHeader = T,
                  dataTableOutput('data_table'),
                  width = NULL
                )
              )
            )),
    #create tab time
    tabItem(tabName = 'time',
            fluidRow(
              column(
                width = 4,
                box(
                  title = 'Select Input',
                  solidHeader = T,
                  status = 'primary',
                  pickerInput(
                    "district",
                    "Choose a District",
                    choices = as.character(unique(dist$district)),
                    selected = as.character(unique(dist$district)),
                    options = list(`actions-box` = TRUE),
                    multiple = T
                  ),
                  dateRangeInput(
                    "date",
                    strong("Date range"),
                    start = min(date_trend$date),
                    end = max(date_trend$date),
                    min = min(date_trend$date),
                    max = max(date_trend$date)
                  ),
                  selectInput(
                    "SelectBy",
                    label = strong("Select Date"),
                    choices = list(
                      "By Year" = 'year',
                      "By Month" = 'month',
                      "By Week" = 'day_of_week',
                      "By Hour" = 'hour',
                      "Ratio Change by Year" = 'ratio'
                    ),
                    selected = 1
                  ),
                  checkboxInput(
                    "Byother",
                    label = strong("Select by Date"),
                    value = FALSE
                  ),
                  width = NULL
                )
              ),
              column(
                width = 8,
                box(
                  title = 'Crime With time',
                  status = 'primary',
                  solidHeader = T,
                  plotlyOutput('date_line'),
                  width = NULL
                )
              )
            ),
            fluidRow(column(
              width = 12,
              box(
                title = 'Privous Data',
                status = 'primary',
                solidHeader = T,
                width = NULL,
                dataTableOutput('date_table')
              )
            ))),
    #create tab word
    tabItem(tabName = 'word',
            fluidRow(column(
              width = 12,
              box(
                title = 'Select Input',
                solidHeader = T,
                status = 'primary',
                selectInput(
                  "district_word",
                  "Choose a District",
                  choices = as.character(unique(dist$district)),
                  selected = as.character(unique(dist$district))[1]
                ),
                sliderInput(
                  "max",
                  "Maximum Number of Words:",
                  min = 1,
                  max = length(unique(dist$offense_code_group)),
                  value = 10,
                  step = 1
                ),
                width = NULL
              )
            )),
            fluidRow(
              column(
                width = 6,
                box(
                  title = 'Word Game',
                  solidHeader = T,
                  status = 'primary',
                  width = NULL,
                  plotOutput('word')
                )
              ),
              column(
                width = 6,
                box(
                  title = 'Different types of crime',
                  solidHeader = T,
                  status = 'primary',
                  width = NULL,
                  plotlyOutput('hist')
                )
              )
            ))
  ))
))
