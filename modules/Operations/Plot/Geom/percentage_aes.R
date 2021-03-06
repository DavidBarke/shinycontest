percentage_aes_ui <- function(id, aes) {
  ns <- shiny::NS(id)
  
  htmltools::tagList(
    shiny::numericInput(
      inputId = ns("percentage"),
      label = NULL,
      value = 1,
      min = 0,
      max = 1,
      step = 0.1
    )
  )
}

percentage_aes <- function(
  input, output, session, .values, aes
) {
  
  ns <- session$ns
  
  debounced_percentage_r <- shiny::reactive({
    shiny::req(input$percentage)
  }) %>% debounce(1000)
  
  shiny::observeEvent(debounced_percentage_r(), {
    if (safe_numeric_input_value(shiny::req(input$percentage)) > 1) {
      shiny::updateNumericInput(
        session = session,
        inputId = "percentage",
        value = 1
      )
    } else if (shiny::req(input$percentage) < 0) {
      shiny::updateNumericInput(
        session = session,
        inputId = "percentage",
        value = 0
      )
    }
  })
  
  return_list <- list(
    value_r = shiny::reactive(max(min(safe_numeric_input_value(fallback(input$percentage, 1)), 1), 0))
  )
  
  return(return_list)
}