#' Calculate stats of hitter over specified time
#'
#' @param firstName A string
#' @param lastName A string
#' @param startDate A string formatted YYYY-MM-DD
#' @param endDate A string formatted YYYY-MM-DD
#' @param playerIndex A positive integer
#'
#' @returns The counting stats of a hitter over a specified period of time
#' @export
#'
#' @examples
#' calculate_hitter_profile("Aaron","Judge", "2024-05-19", "2025-06-05", playerIndex = 1)
calculate_hitter_profile <- function(firstName, lastName, startDate, endDate, playerIndex)
{
  playerID_df <- baseballr::playerid_lookup(last_name = lastName, first_name = firstName)
  print(playerID_df)

  if (nrow(playerID_df) == 0) {
    stop("No players found.")
  }

  if (playerIndex > nrow(playerID_df)) {
    stop("playerIndex exceeds number of matching players.")
  }

  playerID <- playerID_df$mlbam_id[playerIndex]

  data <- baseballr::statcast_search(start_date = startDate, end_date = endDate,
                                     playerid = playerID)

  data <- data |>
    dplyr::mutate(
      hit = dplyr::if_else(
      events %in% c(
        "single",
        "double",
        "triple",
        "home_run"), 1, 0),
      walk = dplyr::if_else(events == "walk", 1, 0),
      HR = dplyr::if_else(events == "home_run", 1, 0),
      intentionalWalk = dplyr::if_else(events == "intent_walk", 1, 0),
      fieldOut = dplyr::if_else(events == "field_out", 1, 0),
      strikeOut = dplyr::if_else(events == "strikeout", 1, 0),
      doublePlay = dplyr::if_else(events == "grounded_into_double_play", 1, 0),
      forceOut = dplyr::if_else(events == "force_out", 1, 0),
      sacFly = dplyr::if_else(events == "sac_fly", 1, 0),
      fielderError = dplyr::if_else(events == "field_error", 1, 0),
      hitByPitch = dplyr::if_else(events == "hit_by_pitch", 1, 0)
      )

  profile <- data |>
    dplyr::summarise(
      Hits = sum(hit, na.rm = TRUE),
      HRs = sum(HR, na.rm = TRUE),
      Walks = sum(walk, na.rm = TRUE),
      IntentionalWalk = sum(intentionalWalk, na.rm = TRUE),
      HitByPitch = sum(hitByPitch, na.rm = TRUE),
      StrikeOut = sum(strikeOut, na.rm = TRUE),
      FieldOut = sum(fieldOut, na.rm = TRUE),
      DoublePlay = sum(doublePlay, na.rm = TRUE),
      ForceOut = sum(forceOut, na.rm = TRUE),
      SacFly = sum(sacFly, na.rm = TRUE),
      FielderError = sum(fielderError, na.rm = TRUE)
    )



  return(profile)
}
