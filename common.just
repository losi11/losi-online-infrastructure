@info message:
    printf "\e[38;5;153mI: %s\e[0m\n" "{{ message }}"

@success message:
    printf "\e[38;5;151mS: %s\e[0m\n" "{{ message }}"

@warn message description:
    printf "\e[38;5;229mW: %s\n   - Description: %s\e[0m\n" "{{ message }}" "{{ description }}"

@error message description:
    printf "\e[38;5;210mE: %s\n   - Description: %s\e[0m\n" "{{ message }}" "{{ description }}"
