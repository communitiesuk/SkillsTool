#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  # Update sub-skill choices based on selected software
  observe({
    software_selected <- input$software
    subskills <- grep(paste0("^", software_selected, ":"), names(analyst_data), value = TRUE)
    subskills <- gsub(paste0("^", software_selected, ": "), "", subskills)
    updateSelectizeInput(session, "subskill", choices = c("Select Skill", subskills), selected = "Select Skill")
  })

  observe({
    updateSelectizeInput(session, "software", selected = NULL)
    updateSelectizeInput(session, "subskill", choices = c("Select Skill", NULL), selected = "Select Skill")
  })

  # Filter data based on selections
  filtered_data <- eventReactive(input$update, {
    software_selected <- input$software
    subskill_selected <- input$subskill

    if (subskill_selected == "Select Skill") {
      result <- analyst_data %>%
        filter(if_any(starts_with(paste0("Would you be capable of helping others with ", software_selected)), ~. == "Yes")) %>%
        select(Name, Email, Team, software_selected) %>%
        arrange(desc(!!sym(software_selected)))
    } else if (!is.null(software_selected) && !is.null(subskill_selected)) {
      subskill_column <- paste0(software_selected, ": ", subskill_selected)
      result <- analyst_data %>%
        filter(if_any(starts_with(paste0("Would you be capable of helping others with ", software_selected)), ~. == "Yes")) %>%
        select(Name, Email, Team ,  software_selected, subskill_column) %>%
        arrange(desc(!!sym(subskill_column)), desc(!!sym(software_selected)))
    } else {
      result <- analyst_data[, c("Name", "Email", "Team", software_selected)]
    }

    result
  })
  # Render the table
  # Render the table
  output$result_table <- renderDT({
    # Check if the "Update" button is clicked before rendering the table
    if (input$update > 0) {
      datatable(filtered_data(), options = list(scrollX = T, scrollY = T))
    } else {
      NULL
    }
  })
}

