test_that("player index isn't correct",{
  # the index is higher than the numbers of returned players
  expect_error(plot_zone_heatmap("Jun","Soto", "2024-05-19", "2025-06-05", playerIndex = 6), "playerIndex exceeds number of matching players.")

  # the index is less than 1
  expect_warning(plot_zone_heatmap("Jun","Soto", "2024-05-19", "2025-06-05", playerIndex = 0), "No valid data found")

  # the index is a decimal
  expect_warning(plot_zone_heatmap("Jun","Soto", "2024-05-19", "2025-06-05", playerIndex = 1.5), "No valid data found")

  # Vectors (length > 1)
  expect_error(plot_zone_heatmap("Jun","Soto", "2024-05-19", "2025-06-05", playerIndex = c(12, 14)), "Assertion on 'playerIndex' failed: Must have length 1.")

  # Characters
  expect_error(plot_zone_heatmap("Juan","Soto", "2024-05-19", "2025-06-05", playerIndex = "1"), "Assertion on 'playerIndex' failed: Must be of type 'number', not 'character'.")

})

test_that("first and last name are spelled incorrectly or not added",{
  # first and last name exist
  expect_error(plot_zone_heatmap("Jn","Soto", "2024-05-19", "2025-06-05", playerIndex = 6), "No players found.")

  # not declaring value for names
  expect_error(plot_zone_heatmap("2024-05-19", "2025-06-05", playerIndex = 6), 'argument "startDate" is missing, with no default')

})

test_that("the dates are formatted correctly and have data for the time period",{
  # dates are not formatted correctly
  expect_error(plot_zone_heatmap("Juan","Soto", "05-19-2024", "2025-06-05", playerIndex = 6), "The data are limited to the 2008 MLB season and after.")

  # there is no data for the given time period
  expect_warning(plot_zone_heatmap("Juan","Soto", "2013-05-01", "2025-06-05", playerIndex = 6), "No valid data found")

  # not declaring value for date
  expect_error(plot_zone_heatmap("Juan", "Soto", "2025-06-05", playerIndex = 6), 'argument "endDate" is missing, with no default')

  # first date is later than second date
  expect_error(plot_zone_heatmap("Juan","Soto","2025-05-19", "2024-06-05", playerIndex = 6), "The start date is later than the end date.")

})

test_that("plot_zone_heatmap returns a valid ggplot2 plot object", {
  # Generate the plot
  my_plot <- plot_zone_heatmap("Juan","Soto", "2024-05-01", "2025-06-05", playerIndex = 6)

  # Check that it is actually a ggplot2 plot
  expect_true(ggplot2::is_ggplot(my_plot))
})
