def fixed_point_to_float_8(binary_str):
    # Convert the binary string to an integer
    int_val = int(binary_str, 2)

    # If the value is negative (i.e., the sign bit is 1), subtract 2^8 to get the negative value
    if int_val & (1 << 7):
        int_val -= 1 << 8

    # Convert the integer to a float and scale it
    float_val = int_val / 2**7

    return float_val

def float_to_fixed_point_8(val):
    # Scale the value to the range -1.0 to 0.9921875
    scaled_val = max(min(val, 0.9921875), -1.0)

    # Convert the scaled value to a binary string
    binary_str = format(int(scaled_val * 2**7), '08b')

    # If the value is negative, flip the bits and add 1 to get the two's complement representation
    if scaled_val < 0:
        binary_str = format((int(binary_str, 2) ^ 0xFF) + 1, '08b')

    return str(binary_str)


def float_to_fixed_point_16(val):
    # Scale the value to the range -32.0 to 31.9990234375
    scaled_val = max(min(val, 31.9990234375), -32.0)

    # Convert the scaled value to a binary string
    binary_str = format(int(scaled_val * 2**10), '016b')

    # If the value is negative, flip the bits and add 1 to get the two's complement representation
    if scaled_val < 0:
        binary_str = format((int(binary_str, 2) ^ 0xFFFF) + 1, '016b')

    return str(binary_str)

def fixed_point_to_float_16(binary_str):
    # Convert the binary string to an integer
    int_val = int(binary_str, 2)

    # If the value is negative (i.e., the sign bit is 1), subtract 2^16 to get the negative value
    if int_val & (1 << 15):
        int_val -= 1 << 16

    # Convert the integer to a float and scale it
    float_val = int_val / 2**10

    return float_val