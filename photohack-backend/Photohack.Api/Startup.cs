using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Photohack.Api.Extensions;
using Photohack.Models;
using Photohack.Services;
using Swashbuckle.AspNetCore.Swagger;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Photohack.Api
{
    /// <summary>
    /// Startup class
    /// </summary>
    public class Startup
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="Startup"/> class.
        /// </summary>
        /// <param name="configuration">The configuration.</param>
        /// <param name="environment">The environment.</param>
        public Startup(IConfiguration configuration, IHostingEnvironment environment)
        {
            Configuration = configuration;
            Environment = environment;
        }

        /// <summary>
        /// Gets the configuration.
        /// </summary>
        /// <value>
        /// The configuration.
        /// </value>
        public IConfiguration Configuration { get; }

        /// <summary>
        /// Gets the environment.
        /// </summary>
        /// <value>
        /// The environment.
        /// </value>
        public IHostingEnvironment Environment { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        /// <summary>
        /// Configures the services.
        /// </summary>
        /// <param name="services">The services.</param>
        public void ConfigureServices(IServiceCollection services)
        {
            var parallelDotsSection = Configuration.GetSection("ParallelDots");
            services.Configure<ParallelDotsConfiguration>(parallelDotsSection);
            //var parallelDotsSectionSettings = parallelDotsSection.Get<ParallelDotsConfiguration>();

            services.AddScoped<IMusicService, MusicService>();
            services.AddScoped<IEmotionService, EmotionService>();
            services.AddScoped<IPhotoService, PhotoService>();
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);

            services.AddHttpClient("deezer", c =>
            {
                c.BaseAddress = new Uri("https://api.deezer.com/");
            });

            services.AddHttpClient("paralleldots", c =>
            {
                c.BaseAddress = new Uri("https://apis.paralleldots.com/");
            });

            services.AddHttpClient("photolab", c =>
            {
                c.BaseAddress = new Uri("http://api-soft.photolab.me/");
            });

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new Info { Title = "CrazyFace api", Version = "v1" });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        /// <summary>
        /// Configures the specified application.
        /// </summary>
        /// <param name="app">The application.</param>
        /// <param name="env">The env.</param>
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.InjectStylesheet("/swagger-ui/styles.css");
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "CrazyFace");
            });

            app.UseStaticFiles();

            app.UseHttpsRedirection();

            app.UseMiddleware<ExceptionMiddleWare>();

            app.UseMvc();
        }
    }
}
