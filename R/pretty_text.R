
#' @importFrom utils globalVariables
#' @importFrom rlang .data
utils::globalVariables(c("markdown_notes", "demo_notes", "emojis"))
markdown_emojis <- function(note){
  emoji_pattern <- "[^\`](:[[a-zA-Z0-9_+-]]+:)"
  start_pattern <- "^(:[[a-zA-Z0-9_+]]+:)"
  if(stringr::str_detect(note, emoji_pattern)||stringr::str_detect(note, start_pattern)){
    
    emoji_names <- stringr::str_extract_all(note, emoji_pattern)[[1]]
    emoji_names <- trimws(emoji_names)
    emoji_names <- gsub("\"", "", emoji_names)
    if(stringr::str_detect(note, start_pattern)){
      emoji_names <- c(emoji_names, stringr::str_extract_all(note, start_pattern)[[1]])
    }
    
    for(i in 1:length(emoji_names)){
      emoji_name <- emoji_names[i]
      emoji_idx <- which(emojis$name == gsub(":", "", emoji_name))
      if(length(emoji_idx) > 0){
        emoji_url <- emojis$url[emoji_idx]        
        htm <- paste0('<img class="emoji" title="', emoji_name, '" alt="', emoji_name, '" src="', emoji_url, '" height="20" width="20" align="absmiddle">')
        
        # Check if emoji contains special characters - escape in regex pattern
        if(stringr::str_detect(emoji_name, "\\+")){
          non_alphanumeric <- as.data.frame(stringr::str_locate_all(emoji_name, "\\+"))
          for(k in 1:nrow(non_alphanumeric)){
            to_replace <- substr(emoji_name, non_alphanumeric$start[k], non_alphanumeric$end[k])
            emoji_name <- gsub(to_replace, paste0("\\",to_replace), emoji_name, fixed = T)  
          }
          emoji_pattern <- emoji_name
        }
        emoji_pattern <- paste0("([^\`]", emoji_name, ")")
        note <- gsub(emoji_pattern, htm, note)
        emoji_pattern <- paste0("^(", emoji_name, ")")
        note <- gsub(emoji_pattern, htm, note)
      }
    }
  }
  return(note)
}


html_emojis <- function(html_note){
  emoji_start_pattern <- '(\\<img\\s+class="emoji")'
  emoji_end_pattern <- '(align="absmiddle"\\>)'
  emoji_name_pattern <- '(title=\\":\\w+:\\")'
  if (stringr::str_detect(html_note, emoji_start_pattern)){
    title_tags <- stringr::str_locate_all(html_note, emoji_name_pattern) %>% as.data.frame()
    
    emoji_titles <- sapply(1:nrow(title_tags), function(x){
      gsub('"', '', gsub('title="', '', substr(html_note, title_tags$start[x], title_tags$end[x])))
    })
    
    for(i in 1:nrow(title_tags)){
      start_tags <- stringr::str_locate_all(html_note, emoji_start_pattern)[[1]] %>% as.data.frame()
      end_tags <- stringr::str_locate_all(html_note, emoji_end_pattern)[[1]] %>% as.data.frame()
      
      html_note <- gsub(substr(html_note, start_tags$start[1], end_tags$end[1]), emoji_titles[i], html_note, fixed = T)
    }
  }
  return(html_note)
}


replace_tag <- function(note){
  note <- gsub("</p>", "", gsub("<p>", "", note))
  note <- gsub("</strong>", "**", gsub("<strong>", "**", note))
  note <- gsub("</strong>", "**", gsub("<strong>", "**", note))
  note <- gsub("</code></pre>", "```", gsub("<pre><code>", "\n```\n", note))
  note <- gsub("</code>", "`", gsub("<code>", "`", note))
  note <- gsub('(<pre><code class=\\"\\w+\\">)', "\n```\n", note)
  note <- gsub("</br>", "\n", note)
  note <- gsub("&#39;", "'", note)
  note <- gsub('&rdquo;', '"', gsub('&ldquo;', '"', note))
  note <- gsub('&quot;', '"', note)
  # Replace header h(1-6)tags
  for(i in 1:6){
    note <- gsub(paste0("</h", i, ">"), "", gsub(paste0("<h", i, ">"), paste0(paste0(rep("#", i), collapse=""), " "), note))
  }

  # Replace hyperlink <a> tags
  note <- gsub('href=[\'"]?([^\'" >]+)', '', note)
  note <- gsub("</a>", "", gsub('<a \">', '', note))

  return(note)
  
}