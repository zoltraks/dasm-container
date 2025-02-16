FROM debian:12-slim

# Create the /dasm directory
RUN mkdir /dasm

# Copy the dasm binaries from the cache directory to /dasm in the image
COPY cache/dasm/* /dasm/

# Make the dasm binaries executable (if needed).  This is important!
RUN chmod +x /dasm/dasm

# Add /dasm to the PATH
ENV PATH="/dasm:$PATH"

# Create the /src directory
RUN mkdir /src

# Set the working directory to /src
WORKDIR /src

# Set the default command to run dasm with any arguments passed to the container
CMD ["dasm"] 
