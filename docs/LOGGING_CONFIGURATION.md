# Logging Configuration

## Overview

Konfigurasi logging untuk aplikasi RSIA Buah Hati Pamulang yang mengoptimalkan output log dengan mengurangi noise dari Tomcat container dan mempersingkat stack trace.

## Implemented Solutions

### 1. Stack Trace Shortening (application.properties)

```properties
# Tampilkan hanya 5 baris pertama stack trace
logging.exception-conversion-word=%ex{5}
```

**Efek:** Semua stack trace di log akan dipangkas menjadi maksimal 5 baris, menampilkan error yang paling relevan.

### 2. Tomcat Container Noise Reduction

```properties
# Reduce Tomcat Container Noise
logging.level.org.apache.catalina=WARN
logging.level.org.apache.coyote=WARN
logging.level.org.apache.tomcat=WARN
logging.level.org.apache.tomcat.util=WARN
logging.level.org.apache.catalina.connector.ClientAbortException=WARN
```

**Efek:** Mengurangi log level untuk komponen Tomcat container, hanya menampilkan WARN dan ERROR.

### 3. Advanced Stack Trace Filtering (logback-spring.xml)

```xml
%replace(%wEx){
  '(?m)^\s*at (org\.apache\.(catalina|tomcat|coyote)|org\.apache\.tomcat\.util)\..*$',
  '\t... [container frames suppressed]'
}%n
```

**Efek:**

- Menyembunyikan frame Tomcat container secara spesifik
- Menampilkan `... [container frames suppressed]` sebagai pengganti
- Frame aplikasi (`com.example.hospital...`) tetap terlihat penuh

## Before vs After

### Before (Long Stack Trace):

```
2025-07-30T14:11:04.815+07:00 ERROR 360511 --- [rsia-buah-hati-pamulang] [nio-8080-exec-3] c.e.h.exception.GlobalExceptionHandler : Terjadi kesalahan umum:
org.apache.catalina.connector.ClientAbortException: java.io.IOException: Broken pipe
    at org.apache.catalina.connector.OutputBuffer.realWriteBytes(OutputBuffer.java:356)
    at org.apache.catalina.connector.OutputBuffer.flushByteBuffer(OutputBuffer.java:426)
    at org.apache.catalina.connector.OutputBuffer.doFlush(OutputBuffer.java:355)
    at org.apache.catalina.connector.OutputBuffer.flush(OutputBuffer.java:317)
    at org.apache.catalina.connector.CoyoteOutputStream.flush(CoyoteOutputStream.java:118)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
    at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:197)
    at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)
    at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)
    at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:868)
    at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1592)
    at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1136)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:635)
    at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
    at java.lang.Thread.run(Thread.java:833)
```

### After (Clean Stack Trace):

```
2025-07-30T14:11:04.815+07:00 ERROR 360511 --- [rsia-buah-hati-pamulang] [nio-8080-exec-3] c.e.h.exception.GlobalExceptionHandler : Terjadi kesalahan umum:
org.apache.catalina.connector.ClientAbortException: java.io.IOException: Broken pipe
    at org.apache.catalina.connector.OutputBuffer.realWriteBytes(OutputBuffer.java:356)
    at org.apache.catalina.connector.OutputBuffer.flushByteBuffer(OutputBuffer.java:426)
    at org.apache.catalina.connector.OutputBuffer.doFlush(OutputBuffer.java:355)
    at org.apache.catalina.connector.OutputBuffer.flush(OutputBuffer.java:317)
    at org.apache.catalina.connector.CoyoteOutputStream.flush(CoyoteOutputStream.java:118)
    ... [container frames suppressed]
```

## Benefits

1. **Cleaner Logs:** Stack trace lebih mudah dibaca dan fokus pada error yang relevan
2. **Reduced Noise:** Mengurangi log dari komponen Tomcat yang tidak penting
3. **Better Performance:** Log file lebih kecil dan processing lebih cepat
4. **Easier Debugging:** Developer dapat fokus pada kode aplikasi, bukan container internals

## Configuration Files

- `src/main/resources/application.properties` - Basic logging configuration
- `src/main/resources/logback-spring.xml` - Advanced logging configuration
- `src/main/java/com/example/hospital/exception/GlobalExceptionHandler.java` - Exception handling

## Log Files

- **Console:** Output langsung ke terminal
- **File:** `logs/hospital-app.log` dengan rolling policy (10MB max, 30 hari retention)

## Customization

### Untuk mengubah jumlah baris stack trace:

```properties
# Tampilkan 10 baris
logging.exception-conversion-word=%ex{10}

# Tampilkan hanya jenis exception
logging.exception-conversion-word=%ex{short}
```

### Untuk menambahkan package lain yang disuppress:

```xml
<!-- Di logback-spring.xml, tambahkan ke regex pattern -->
'(?m)^\s*at (org\.apache\.(catalina|tomcat|coyote)|org\.apache\.tomcat\.util|package\.to\.suppress)\..*$'
```
