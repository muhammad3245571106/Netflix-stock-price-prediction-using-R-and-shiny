#Libraries
library(shiny)
library(shinydashboard)
library(plotly)
library(datasets)
library(skimr)
library(shinycssloaders)
library(shinyWidgets)

#Plot Size
plotWidth <- 1000
plotHeight <- 700

#color
defaultColor = "red"

#UI
shinyUI(
  dashboardPage(skin = defaultColor,
                dashboardHeader(title = "Netflix stock price",
                                tags$li(class="dropdown",tags$a(href="https://www.netflix.com/pk/", icon("globe"), "Go to website", target="_blank")),
                                tags$li(class="dropdown",tags$a(href="https://www.google.com/finance/quote/NFLX:NASDAQ?sa=X&ved=2ahUKEwjO08jb2u3-AhVDP-wKHdhWB0gQ3ecFegQIKxAf", icon("google"), "Check stock prices live", target="_blank"))
                ),
                dashboardSidebar(
                                 sidebarMenu(id="sidebar", color = defaultColor,
                                   menuItem("Data",tabName = "data",icon = icon("database"),
                                            menuSubItem("Dataset",tabName = "ds", icon = icon("table")),
                                            menuSubItem("Structure",tabName = "st", icon = icon("uncharted")),
                                            menuSubItem("Summary",tabName = "sum", icon = icon("chart-pie"))
                                            ),
                                   menuItem("Visualization", tabName = "visualization", icon = icon("chart-line"),
                                            menuSubItem("Line Graph",tabName = "lo", icon = icon("chart-line")),
                                            menuSubItem("Line Graph(365 days)",tabName = "ly", icon = icon("chart-line")),
                                            menuSubItem("Line Graph(30 days)",tabName = "lm", icon = icon("chart-line")),
                                            menuSubItem("Scatter plot",tabName = "sp", icon=icon("circle")),
                                            menuSubItem("Boxplot of Closing Value",tabName = "bc", icon=icon("th-large", lib = "glyphicon")),
                                            menuSubItem("Histogram of Volume",tabName = "hv", icon=icon("stats", lib="glyphicon"))),
                                   menuItem("Probability distribution", tabName = "pd", icon=icon("area-chart")),
                                   menuItem(" Regression model",tabName = "Regression Model",icon = icon("gears"),
                                            menuSubItem("Summary Regression Model",tabName = "rms", icon = icon("chart-pie")),
                                            menuSubItem("Prediction",tabName = "rm", icon = icon("cogs"))),
                                   menuItem("Confidence interval", tabName = "ci",icon=icon("bars"),
                                            menuSubItem("Descriptive measure",tabName = "dci",icon=icon("table")),
                                            menuSubItem(" ReggreSsion estimates",tabName = "rci",icon=icon("cog"))))
                ),
                dashboardBody(
                  tabItems(
                    tabItem(tabName = "ds",dataTableOutput("dsp")),
                    tabItem(tabName = "st",fluidRow(verbatimTextOutput("st"))),
                    tabItem(tabName = "sum",fluidRow(verbatimTextOutput("sum"))),
                    tabItem(tabName = "lo",
                            fluidRow(box(title = "Line Graph", width=plotWidth,dateInput(inputId = "lsd", label = "Select start date", value = "2021-01-01"),dateInput(inputId = "led", label = "Select end date", value = "2022-01-01"), plotlyOutput("lop",height=plotHeight)))),
                    tabItem(tabName = "ly",
                            fluidRow(box(title = "Line Graph (365 days)", width=plotWidth,plotlyOutput("lyp",height=plotHeight)))),
                    tabItem(tabName = "lm",
                            fluidRow(box(title = "Line Graph (30 days)", width=plotWidth,plotlyOutput("lmp",height=plotHeight)))),
                    tabItem(tabName = "sp",
                            fluidRow(box(title = "Scatter plot", width=plotWidth,
                                         dateInput(inputId = "ssd", label = "Select start date", value = "2021-01-01"),dateInput(inputId = "sed", label = "Select end date", value = "2022-01-01"),
                                         radioButtons(inputId ="fit" , label = "Select smooth method" , choices = c("loess", "lm"), selected = "lm" , inline = TRUE), 
                                         withSpinner(plotlyOutput("spp")), value="relation", height=plotHeight)
                                         )),
                    tabItem(tabName = "bc",
                            fluidRow(box(title = "Boxplot", width=plotWidth,plotlyOutput("bcp",height=plotHeight)))),
                    tabItem(tabName = "hv",
                            fluidRow(box(title = "Histogram of Volume", width=plotWidth,plotlyOutput("hvp",height=plotHeight)))),
                    tabItem(tabName = "pd",
                            fluidRow(box(title = "Normal distribution plot",width=plotWidth,plotlyOutput("pdp",height=plotHeight)))),
                    tabItem(tabName = "rms",fluidRow(verbatimTextOutput("rms"))),
                    tabItem(tabName = "rm",numericInput("num", h3("Enter Opening Value:"), value = "100"),fluidRow(valueBoxOutput("rm",width = 4))),
                    tabItem(tabName = "dci",fluidRow(verbatimTextOutput("dci"))),
                    tabItem(tabName = "rci",fluidRow(verbatimTextOutput("rci")))
                  )
                )
  )
)