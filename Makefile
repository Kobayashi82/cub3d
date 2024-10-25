# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ozini <ozini@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/16 11:45:10 by vzurera-          #+#    #+#              #
#    Updated: 2024/06/22 17:23:48 by ozini            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# ───────────────────────────────────────────────────────────── #
# ─────────────────────── CONFIGURATION ─────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ──────────── #
# ── COLORS ── #
# ──────────── #

RED     			= \033[0;31m
GREEN   			= \033[0;32m
YELLOW  			= \033[0;33m
BLUE    			= \033[0;34m
MAGENTA 			= \033[0;35m
CYAN    			= \033[0;36m
WHITE   			= \033[0;37m
NC    				= \033[0m
INV_RED  			= \033[7;31m
INV_GREEN	  		= \033[7;32m
INV_YELLOW  		= \033[7;33m
INV_BLUE  			= \033[7;34m
INV_MAGENTA			= \033[7;35m
INV_CYAN			= \033[7;36m
INV_WHITE			= \033[7;37m
BG_CYAN				= \033[43m
FG_YELLOW			= \033[89m
COUNTER 			= 0

# ─────────── #
# ── FLAGS ── #
# ─────────── #

CLANG				= clang
FLAGS				= -Wall -Wextra -Werror -g #-fsanitize=address
EXTRA_FLAGS			= -ldl -lglfw -pthread -lm 
# ───────────────── #
# ── DIRECTORIES ── #
# ───────────────── #

INC_DIR				= ./inc/
OBJ_DIR				= ./build/obj/
LIB_DIR				= ./build/lib/
SRC_DIR				= ./src/$(NAME)/
SRC_DIR_B			= ./src/$(NAME_B)_bonus/
LIBFT_INC			= ./src/libft/inc/
LIBFT_DIR			= ./src/libft/
LIBFT				= libft.a
MLX_INC				= ./src/MLX42/include/MLX42/
MLX_DIR				= ./src/MLX42/
MLX 				= libmlx42.a

# ─────────────── #
# ── VARIABLES ── #
# ─────────────── #

ENABLE_LIBFT		= 1
ENABLE_MLX			= 1
ENABLE_BONUS		= 0
ENABLE_NORMINETTE	= 1

# ────────── #
# ── NAME ── #
# ────────── #

NAME				= cub3D
NAME_B				= cub3D

# ─────────── #
# ── FILES ── #
# ─────────── #

SRCS	=	parsing/textures.c parsing/rgb.c parsing/parsing.c parsing/map.c	\
			parsing/validate_map.c												\
																				\
			ray_casting/angles.c ray_casting/distances.c						\
			ray_casting/horizontal_intersections.c								\
			ray_casting/vertical_intersections.c								\
			ray_casting/projection_data.c										\
			ray_casting/draw_image.c ray_casting/ray_casting.c					\
																				\
			moves/move.c moves/delta_time.c										\
																				\
			clean/errors.c clean/free.c											\
																				\
			main.c

SRCS_B	= 	

# ────────────────────────────────────────────────────────── #
# ───────────────────────── NORMAL ───────────────────────── #
# ────────────────────────────────────────────────────────── #

all: $(NAME)

OBJS		= $(SRCS:%.c=$(OBJ_DIR)%.o)
DEPS		= $(OBJS:.o=.d)
-include $(DEPS)

$(NAME): normal_1 $(OBJS)
#	Compile program
	@if [ -f $(NAME) ]; then \
		printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME)$(NC)"; \
	else \
		printf "\r%50s\r\t$(CYAN)Compiling... $(YELLOW)$(NAME)$(NC)"; \
	fi
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ] && [ "$(ENABLE_MLX)" = "1" ] && [ -d "$(MLX_DIR)" ]; then \
        $(CLANG) $(FLAGS) -I$(INC_DIR) $(OBJS) $(LIB_DIR)$(LIBFT) $(MLX_DIR)$(MLX) $(EXTRA_FLAGS) -o $(NAME); \
    elif [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ] && [ "$(ENABLE_MLX)" != "1" ]; then \
        $(CLANG) $(FLAGS) -I$(INC_DIR) $(OBJS) $(LIB_DIR)$(LIBFT) $(EXTRA_FLAGS) -o $(NAME); \
    elif [ "$(ENABLE_LIBFT)" != "1" ] && [ "$(ENABLE_MLX)" = "1" ] && [ -d "$(MLX_DIR)" ]; then \
        $(CLANG) $(FLAGS) -I$(INC_DIR) $(OBJS) $(MLX_DIR)$(MLX) $(EXTRA_FLAGS) -o $(NAME); \
    else \
        $(CLANG) $(FLAGS) -I$(INC_DIR) $(OBJS) $(EXTRA_FLAGS) -o $(NAME); \
    fi
	@printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME)$(NC)\n"
#	Progress line
	@$(MAKE) -s progress
#	Norminette
	@if [ "$(ENABLE_NORMINETTE)" = "1" ]; then \
		printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"; \
		printf "\r%50s\r\t$(CYAN)Norminette  $(YELLOW)scanning...$(NC)"; \
		output2=""; \
		if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then output2=$$(norminette $(LIBFT_DIR) 2>&1); fi; \
		output1=$$(norminette $(SRC_DIR) 2>&1); \
		if echo $$output1 $$output2 | grep -q "Error"; then \
			printf "\r%50s\r\t$(CYAN)Norminette  $(RED)X $(YELLOW)errors$(NC)\n"; \
		else \
			printf "\r%50s\r\t$(CYAN)Norminette  $(GREEN)✓ $(YELLOW)perfect$(NC)\n"; \
		fi; \
		$(MAKE) -s progress; \
	fi;
	@printf "\n"
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────── #
# ── OBJECTS ── #
# ───────────── #

$(OBJ_DIR)%.o: $(SRC_DIR)%.c
#	Create folder
	@mkdir -p $(@D)
#	Compile object
	@filename=$$(basename $<); filename=$${filename%.*}; \
	BAR=$$(printf "/ ─ \\ |" | cut -d" " -f$$(($(COUNTER) % 4 + 1))); \
	printf "\r%50s\r\t$(CYAN)Compiling... $(GREEN)$$BAR  $(YELLOW)$$filename$(NC)"; \
	$(eval COUNTER=$(shell echo $$(($(COUNTER)+1))))
	@$(CLANG) $(FLAGS) -I$(INC_DIR) -I$(LIBFT_INC) -I$(MLX_INC) -MMD -o $@ -c $<

# ───────────────── #
# ── EXTRA RULES ── #
# ───────────────── #

normal_1:
	@if [ ! -d "$(SRC_DIR)" ]; then \
		printf "\n\t$(CYAN)source files doesn't exist\n\n$(NC)"; \
		rm -f .is_re; \
		exit 1; \
	fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Create folders
	@mkdir -p build/lib
#	Title
	@if [ ! -f .is_re ]; then clear; \
		$(MAKE) -s title; \
	fi; rm -f .is_re
#	Compile LIBFT
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s all -C $(LIBFT_DIR)/; exit 0); $(MAKE) -s hide_cursor; \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
#	Compile MLX
	@if [ "$(ENABLE_MLX)" = "1" ] && [ -d "$(MLX_DIR)" ]; then \
		printf "\n\t─────────────────────────$(NC)\033[1A\r"; \
		if [ ! -f $(MLX_DIR)$(MLX) ]; then \
			printf "\r%50s\r\t$(CYAN)Compiling... $(YELLOW)$(MLX)$(NC)"; \
			(make -s all -C $(MLX_DIR)/ > /dev/null 2>&1; exit 0); \
    	fi; \
		printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(MLX)$(NC)\n"; \
		$(MAKE) -s progress; \
	fi
	@printf "\n\t─────────────────────────$(NC)\033[1A\r"

# ───────────────────────────────────────────────────────── #
# ───────────────────────── BONUS ───────────────────────── #
# ───────────────────────────────────────────────────────── #

$(NAME_B)_bonus: bonus

OBJS_B		= $(SRCS_B:%.c=$(OBJ_DIR)%.o)
DEPS_B		= $(OBJS_B:.o=.d)
-include $(DEPS_B)

bonus: bonus_1 $(OBJS_B)
#	Compile program
	@printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"
	@if [ -f $(NAME_B) ]; then \
		printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME_B)$(NC)"; \
    else \
		printf "\r%50s\r\t$(CYAN)Compiling... $(YELLOW)$(NAME_B)$(NC)"; \
    fi
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ] && [ "$(ENABLE_MLX)" = "1" ] && [ -d "$(MLX_DIR)" ]; then \
        $(CLANG) $(FLAGS) -I$(INC_DIR) $(OBJS_B) $(LIB_DIR)$(LIBFT) $(MLX_DIR)$(MLX) $(EXTRA_FLAGS) -o $(NAME_B); \
    elif [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ] && [ "$(ENABLE_MLX)" != "1" ]; then \
        $(CLANG) $(FLAGS) -I$(INC_DIR) $(OBJS_B) $(LIB_DIR)$(LIBFT) $(EXTRA_FLAGS) -o $(NAME_B); \
    elif [ "$(ENABLE_LIBFT)" != "1" ] && [ "$(ENABLE_MLX)" = "1" ] && [ -d "$(MLX_DIR)" ]; then \
        $(CLANG) $(FLAGS) -I$(INC_DIR) $(OBJS_B) $(MLX_DIR)$(MLX) $(EXTRA_FLAGS) -o $(NAME_B); \
    else \
        $(CLANG) $(FLAGS) -I$(INC_DIR) $(OBJS_B) $(EXTRA_FLAGS) -o $(NAME_B); \
    fi
	@printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME_B)$(NC)\n"
#	Progress line
	@$(MAKE) -s progress
#	Norminette
	@if [ "$(ENABLE_NORMINETTE)" = "1" ]; then \
		printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"; \
		printf "\r%50s\r\t$(CYAN)Norminette  $(YELLOW)scanning...$(NC)"; \
		output1=$$(norminette $(SRC_DIR_B) 2>&1); \
		output2=""; \
		if [ $(ENABLE_LIBFT) = "1" ] && [ -d "$(LIBFT_DIR)" ]; then output2=$$(norminette $(LIBFT_DIR) 2>&1); fi; \
    	if echo $$output1 $$output2 | grep -q "Error"; then \
        	printf "\r%50s\r\t$(CYAN)Norminette  $(RED)X $(YELLOW)errors$(NC)\n"; \
    	else \
			printf "\r%50s\r\t$(CYAN)Norminette  $(GREEN)✓ $(YELLOW)perfect$(NC)\n"; \
    	fi; \
		$(MAKE) -s progress; \
	fi; printf "\n"
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────── #
# ── OBJECTS ── #
# ───────────── #

$(OBJ_DIR)%.o: $(SRC_DIR_B)%.c
#	Create folder
	@mkdir -p $(@D)
#	Compile object
	@filename=$$(basename $<); filename=$${filename%.*}; \
	BAR=$$(printf "/ ─ \\ |" | cut -d" " -f$$(($(COUNTER) % 4 + 1))); \
	printf "\r%50s\r\t$(CYAN)Compiling... $(GREEN)$$BAR  $(YELLOW)$$filename$(NC)"; \
	$(eval COUNTER=$(shell echo $$(($(COUNTER)+1))))
	@$(CLANG) $(FLAGS) -I$(INC_DIR) -I$(LIBFT_INC) -I$(MLX_INC) -MMD -o $@ -c $<

# ───────────────── #
# ── EXTRA RULES ── #
# ───────────────── #

bonus_1:
	@if [ $(ENABLE_BONUS) = "0" ] || [ ! -d "$(SRC_DIR_B)" ]; then \
		printf "\n\t$(YELLOW)BONUS $(CYAN)is disabled in Makefile or source files doesn't exist\n\n$(NC)"; \
		rm -f .is_re; \
		exit 1; \
	fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Create folders
	@mkdir -p build/lib
#	Title
	@if [ ! -f .is_re ]; then clear; \
		$(MAKE) -s title_bonus; \
	fi; rm -f .is_re
#	Compile LIBFT
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s all -C $(LIBFT_DIR)/; exit 0); $(MAKE) -s hide_cursor; \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
#	Compile MLX
	@if [ $(ENABLE_MLX) = "1" ] && [ -d "$(MLX_DIR)" ]; then \
		printf "\n\t─────────────────────────$(NC)\033[1A\r"; \
		if [ ! -f $(MLX_DIR)$(MLX) ]; then \
			printf "\r%50s\r\t$(CYAN)Compiling... $(YELLOW)$(MLX)$(NC)"; \
			(make -s all -C $(MLX_DIR)/ > /dev/null 2>&1; exit 0); \
    	fi; \
		printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(MLX)$(NC)\n"; \
		$(MAKE) -s progress; \
	fi
	@printf "\n\t─────────────────────────$(NC)\033[1A\r"

# ───────────────────────────────────────────────────────────── #
# ────────────────────────── RE-MAKE ────────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ──────── #
# ── RE ── #
# ──────── #

re:
	@rm -f .is_re
	@if [ ! -d "$(SRC_DIR)" ]; then \
		printf "\n\t$(CYAN)source files doesn't exist\n\n$(NC)"; \
		exit 1; \
	fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
	@$(MAKE) -s fclean
#	Create files
	@touch .is_re
	@printf "\033[1A\033[1A\r"
#	Execute $(NAME)
	@$(MAKE) -s $(NAME)

# ───────── #
# ── REB ── #
# ───────── #

reb:
	@rm -f .is_re
	@if [ $(ENABLE_BONUS) = "0" ] || [ ! -d "$(SRC_DIR_B)" ]; then \
		printf "\n\t$(YELLOW)BONUS $(CYAN)is disabled in Makefile or source files doesn't exist\n\n$(NC)"; \
		exit 1; \
	fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
	@$(MAKE) -s fcleanb
#	Create files
	@touch .is_re
	@printf "\033[1A\033[1A\r"
#	Execute $(NAME)
	@$(MAKE) -s bonus

# ───────────────────────────────────────────────────────────── #
# ─────────────────────────── CLEAN ─────────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ─────────── #
# ── CLEAN ── #
# ─────────── #

clean:
	@rm -f .is_re
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Title
	@clear
	@printf "\n$(NC)"
	@$(MAKE) -s title
#	Delete objects
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s delete_objects -C $(LIBFT_DIR)/; exit 0); \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
	@$(MAKE) -s delete_objects
	@$(MAKE) -s delete_objects_b
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)objects$(NC)\n"
#	Progress line
	@$(MAKE) -s progress; printf "\n"
#	Restore cursor
	@$(MAKE) -s show_cursor

# ──────────── #
# ── CLEANB ── #
# ──────────── #

cleanb:
	@rm -f .is_re
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Title
	@clear
	@printf "\n$(NC)"
	@$(MAKE) -s title_bonus
#	Delete objects
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s delete_objects -C $(LIBFT_DIR)/; exit 0); \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
	@$(MAKE) -s delete_objects_b
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)objects$(NC)\n"
#	Progress line
	@$(MAKE) -s progress; printf "\n"
	@if [ -d "$(OBJ_DIR)" ] && [ -z "$(shell ls -A $(OBJ_DIR) 2>/dev/null)" ]; then rmdir $(OBJ_DIR); fi
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────────────────────────────────────────────────────── #
# ────────────────────────── F-CLEAN ────────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ──────────── #
# ── FCLEAN ── #
# ──────────── #

fclean:
	@rm -f .is_re
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Title
	@clear
	@$(MAKE) -s title
#	Delete LIBFT
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s -C $(LIBFT_DIR) fclean; exit 0); \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
#	Delete MLX
	@if [ $(ENABLE_MLX) = "1" ] && [ -d "$(MLX_DIR)" ]; then \
		printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"; \
		if [ -f $(MLX_DIR)$(MLX) ]; then \
			(make -s fclean -C $(MLX_DIR)/ > /dev/null 2>&1; exit 0); \
			printf "\t$(CYAN)Deleting... $(YELLOW)$(MLX)$(NC)"; \
			rm -f $(MLX_DIR)$(MLX); \
		fi; \
		printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)$(MLX)$(NC)\n"; \
  		$(MAKE) -s progress; \
	fi
#	Delete objects
	@$(MAKE) -s delete_objects
	@$(MAKE) -s delete_objects_b
#	Delete $(NAME)
	@if [ -f $(NAME) ]; then \
		printf "\t$(CYAN)Deleting... $(YELLOW)$(NAME)$(NC)"; \
		rm -f $(NAME); \
	fi
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)$(NAME)$(NC)\n"
	@$(MAKE) -s progress
#	Delete $(NAME_B)
	@if [ -f $(NAME_B) ]; then \
		printf "\t$(CYAN)Deleting... $(YELLOW)$(NAME_B)$(NC)"; \
		rm -f $(NAME_B); \
		printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)$(NAME_B)$(NC)\n"; \
		$(MAKE) -s progress; \
	fi
	@printf "\n"
#	Delete folder and files
	@-rm -d $(LIB_DIR) >/dev/null 2>&1 || true
	@-rm -d ./build >/dev/null 2>&1 || true
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────── #
# ── FCLEANB ── #
# ───────────── #

fcleanb:
	@rm -f .is_re
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Title
	@clear
	@$(MAKE) -s title_bonus
#	Delete LIBFT
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s -C $(LIBFT_DIR) fclean; exit 0); \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
#	Delete MLX
	@if [ $(ENABLE_MLX) = "1" ] && [ -d "$(MLX_DIR)" ]; then \
		printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"; \
		if [ -f $(MLX_DIR)$(MLX) ]; then \
			(make -s fclean -C $(MLX_DIR)/ > /dev/null 2>&1; exit 0); \
			printf "\t$(CYAN)Deleting... $(YELLOW)$(MLX)$(NC)"; \
			rm -f $(MLX_DIR)$(MLX); \
		fi; \
		printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)$(MLX)$(NC)\n"; \
		$(MAKE) -s progress; \
	fi
#	Delete objects
	@$(MAKE) -s delete_objects_b
#	Delete $(NAME_B)
	@if [ -f $(NAME_B) ]; then \
		printf "\t$(CYAN)Deleting... $(YELLOW)$(NAME_B)$(NC)"; \
		rm -f $(NAME_B); \
	fi
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)$(NAME_B)$(NC)\n"
	@$(MAKE) -s progress
	@printf "\n"
#	Delete folder and files
	@-rm -d $(LIB_DIR) >/dev/null 2>&1 || true
	@-rm -d ./build >/dev/null 2>&1 || true
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────────────────────────────────────────────────────── #
# ───────────────────────── FUNCTIONS ───────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ─────────── #
# ── TITLE ── #
# ─────────── #

title:
	@printf "\n$(NC)\t$(INV_CYAN)          $(shell echo CUBE3D | tr a-z A-Z | tr '_' ' ')         $(NC)\n"

title_bonus:
	@printf "\n$(NC)\t$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN)    $(NC)$(INV_CYAN)$(shell echo CUBE3D | tr a-z A-Z)$(INV_CYAN)   $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(NC)\n"

# ───────────────── #
# ── HIDE CURSOR ── #
# ───────────────── #

hide_cursor:
	@printf "\e[?25l"
 
# ───────────────── #
# ── SHOW CURSOR ── #
# ───────────────── #

show_cursor:
	@printf "\e[?25h"

# ──────────────────── #
# ── DELETE OBJECTS ── #
# ──────────────────── #

delete_objects:
	@printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"
	@if [ -n "$(shell ls -A $(OBJ_DIR) 2>/dev/null)" ]; then \
		COUNTER=0; \
		for file in $$(find $(OBJ_DIR) -name "*.o"); do \
			BAR=$$(printf "/ ─ \\ |" | cut -d" " -f$$((COUNTER % 4 + 1))); \
			filename=$$(basename $$file); \
			for src in $(SRCS); do \
				srcname=$$(basename $$src .c); \
				if [ $$filename = $$srcname.o ]; then \
					rm -f $$file $$(dirname $$file)/$$srcname.d; \
					filename=$${filename%.*}; \
					printf "\r%50s\r\t$(CYAN)Deleting... $(GREEN)$$BAR $(YELLOW)$$filename$(NC)"; sleep 0.05; \
					COUNTER=$$((COUNTER+1)); \
					break; \
				fi; \
			done; \
		done; \
	fi; printf "\r%50s\r"
	@-rm -rf $(OBJ_DIR) >/dev/null 2>&1 || true

delete_objects_b:
	@printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"
	@if [ -n "$(shell ls -A $(OBJ_DIR) 2>/dev/null)" ]; then \
		COUNTER=0; \
		for file in $$(find $(OBJ_DIR) -name "*.o"); do \
			BAR=$$(printf "/ ─ \\ |" | cut -d" " -f$$((COUNTER % 4 + 1))); \
			filename=$$(basename $$file); \
			for src in $(SRCS_B); do \
				srcname=$$(basename $$src .c); \
				if [ $$filename = $$srcname.o ]; then \
					rm -f $$file $$(dirname $$file)/$$srcname.d; \
					filename=$${filename%.*}; \
					printf "\r%50s\r\t$(CYAN)Deleting... $(GREEN)$$BAR $(YELLOW)$$filename$(NC)"; sleep 0.05; \
					COUNTER=$$((COUNTER+1)); \
					break; \
				fi; \
			done; \
		done; \
	fi; printf "\r%50s\r"
	@-rm -rf $(OBJ_DIR) >/dev/null 2>&1 || true

# ─────────────────── #
# ── PROGRESS LINE ── #
# ─────────────────── #

progress:
	@total=25; printf "\r\t"; for i in $$(seq 1 $$total); do printf "─"; sleep 0.001; done; printf "$(NC)"
	@total=25; printf "\r\t"; for i in $$(seq 1 $$total); do printf "─"; sleep 0.001; done; printf "\n$(NC)"

# ─────────── #
# ── PHONY ── #
# ─────────── #

.PHONY: all clean cleanb fclean fcleanb re reb bonus normal_1 bonus_1 delete_objects delete_objects_b title title_bonus hide_cursor show_cursor progress
