#variables

internList <- scan("Intern List.csv", sep=",", what=list('character'))
staffList <- read.table("isbAllStaff",header=FALSE, sep="\t")
dataDir <- "data" #directory for data
newLine <- ""

library(shiny)
library(shinyTime)

ui <- fluidPage(headerPanel(
                tags$h1("QIP."),
                tags$h2("6/21/18")
                ),
                sidebarLayout(
                  sidebarPanel(
                    dateInput('date',
                              label = 'Date: yyyy-mm-dd',
                              value = Sys.Date()),
                    selectInput("name", "Who are you?",
                                choices = internList[[1]]),
                    selectInput("partner", "Who did you interact with?",
                                choices = staffList[[1]]),
                    selectInput("type", "Interaction Type:",
                                c("Administrative" = "adm",
                                  "Programming" = "prg",
                                  "Data" = "data",
                                  "Biology" = "bio",
                                  "Consulting" = "con",
                                  "Social" = "soc")),
                    timeInput("time", "Time:", value = strptime("12:00:00", "%T")),
                    numericInput("dur", "Duration (min):", 2, min = 1),
                    #verbatimTextOutput("value"),
                    actionButton(inputId = "submit", 
                                 label = "Submit"),
                    
                    tableOutput("data")
                  ),
                  mainPanel(
                    
                  )
                )
                )
                

server <- function(input,output) {
  
  observeEvent(input$submit, {newLine <- data.frame("date" = as.character.Date(input$date),
    		      		"a" = input$name,
				"b" = input$partner,
				"type" = input$type,
				"startTime" = as.character.Date(input$time),
				"duration" = input$dur,
				stringsAsFactors = FALSE)

			print(newLine)
        		filename <- sprintf("%s/interaction-%s.RData",dataDir, Sys.time())
			save(newLine, file = filename)

			print("DONE")
  })
}

shinyApp(ui=ui,server=server)