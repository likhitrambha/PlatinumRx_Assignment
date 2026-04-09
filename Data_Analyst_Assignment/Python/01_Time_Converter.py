# Time Converter: Convert minutes to hours and minutes

def convert_minutes(total_minutes):
    hours = total_minutes // 60
    minutes = total_minutes % 60
    return f"{hours} hrs {minutes} minutes"

# Example
print(convert_minutes(110))  # 2 hrs 10 minutes