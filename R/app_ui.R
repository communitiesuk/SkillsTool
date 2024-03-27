#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny dplyr shinyGovstyle DT readxl
#' @noRd
app_ui <- function(request) {

  fluidPage(

  shinyGovstyle::header("DLUHC ADD", "Analyst Skills Tool", logo="shinyGovstyle/images/moj_logo.png"),
  banner("banner", "beta", 'This data was last updated on 15/12/2023'),
  gov_layout(size = "full"
  ),

  sidebarLayout(
    sidebarPanel(
      selectizeInput("software", "Select Software", choices = c("Select Software","R", "Python", "SQL", "Excel", "PowerBI", "GitHub", "SPSS", "QGIS", "STATA"), multiple = FALSE),
      hr(),
      selectizeInput("subskill", "Select Sub-Skill", choices = c("Select Skill",NULL), multiple = FALSE,),
      hr(),
      button_Input(inputId = "update", label = "Update", type = "start"),
    ),

    mainPanel(
      div(class = "custom-box",
          h3("Who could help:"),
          div(DTOutput("result_table"))
      )
    )
  ),

  footer(TRUE)
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "SkillsTool"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
