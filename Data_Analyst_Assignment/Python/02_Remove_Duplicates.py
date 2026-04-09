# Remove Duplicates: Remove duplicate characters from string

def remove_duplicates(input_string):
    result = ""
    for char in input_string:
        if char not in result:
            result += char
    return result

# Example
print(remove_duplicates("happy"))  # hapy