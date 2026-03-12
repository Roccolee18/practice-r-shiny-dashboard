library(shiny)
library(bslib)
library(dplyr)
library(plotly)
library(ggridges)
library(ggplot2)
install.packages("rsconnect")

rsconnect::writeManifest(appDir = ".", appPrimaryDoc = "app.R")


# Load data
data <- read.csv(
  "data/supply_chain_data.csv",
  check.names = FALSE
)

# UI
app_ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "apple-style.css"),
    HTML('
      <div class="aurora-orb aurora-orb-1"></div>
      <div class="aurora-orb aurora-orb-2"></div>
      <div class="aurora-orb aurora-orb-3"></div>
    ')
  ),
  div(
    titlePanel("✨ Supply Chain Dashboard"),
    style = "margin-top: 15px; margin-bottom: 15px;"
  ),
  sidebarLayout(
    sidebarPanel(
      h5("🎛️ Global Filters"),
      selectInput(
        "input_product_type",
        "Product Category",
        choices = c("All", sort(unique(data$`Product type`)))
      )
    ),
    mainPanel(
      plotOutput("plot_customer_demo"),
      plotOutput("plot_availability")
    )
  )
)

# Server
server <- function(input, output, session) {
  CP <- c("#45B7D1", "#DDA0DD")
  
  filtered_data <- reactive({
    df_copy <- data
    if (input$input_product_type != "All") {
      df_copy <- df_copy[df_copy$`Product type` == input$input_product_type, ]
    }
    df_copy
  })
  
  output$plot_customer_demo <- renderPlot({
    ggplot(filtered_data(), aes(y = reorder(`Customer demographics`, `Customer demographics`, length))) +
      geom_bar(fill = CP[1]) +
      labs(x = "Total Customers", y = NULL) +
      theme_minimal()
  })
  
  output$plot_availability <- renderPlot({
    filtered_data() |>
      group_by(`Product type`) |>
      summarise(total = sum(Availability)) |>
      ggplot(aes(x = total, y = reorder(`Product type`, total))) +
      geom_bar(stat = "identity", fill = CP[2]) +
      labs(x = "Units in Stock", y = NULL) +
      theme_minimal()
  })
  
}

# Create app
shinyApp(ui = app_ui, server = server)